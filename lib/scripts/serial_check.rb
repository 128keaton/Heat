require 'json'
require 'net/http'
require 'uri'
require 'highline/import'

#get machine serial number
serial = `sudo dmidecode -t 1 | grep Serial | sed 's/.*: //g'`.chomp
base_url = 'http://10.0.2.7:3001'

# Checks if the machine is imaged
uri = URI.parse("#{base_url}/api/check_imaged?serial=#{serial}")
begin
  response = Net::HTTP.get_response(uri)
rescue Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError
  retry
end

# Parses API response
body = JSON.parse(response.body)

# Checks if the API returns that the machine is imaged
if body['imaged']
  confirm = ask('Re-image machine? [Y/N] ') {|yn| yn.limit = 1, yn.validate = /[yn]/i}

  # Confirms that we'd like to re-image
  if confirm.downcase != 'y'
    Kernel.exit(false)
  end
end

puts 'Continuing with imaging'

#Request image from server and set image to response
puts serial
system("sudo ocs-sr -g auto -ius -icrc -irhr -scr -icds -p command restoredisk scs_master3 sda")

if system("sudo mkdir /media/winos")
    if system("sudo mount -t ntfs -o remove_hiberfile /dev/sda4 /media/winos")
      if system("sudo cp /home/imaging/SCS/* /media/winos/SCS\\ Additional\\ Software/")
        puts "Copied scripts successfully!"
      end
      system("sudo umount /dev/sda4")
    end
end

#Debugging, mostly
puts serial

uri = URI.parse("#{base_url}/api/set_imaged?serial=#{serial}")
begin
  Net::HTTP.get_response(uri)
rescue Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError
  retry
end


system("reboot")