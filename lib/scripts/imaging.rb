require 'json'
require 'net/http'
require 'uri'
require 'logger'

logger = Logger.new(STDOUT)

base_url = 'http://10.0.2.7:3001'
serial = `sudo dmidecode -t 1 | grep Serial | sed 's/.*: //g'`.strip!

logger.info "Starting imaging on #{serial}"

# Request image from server and set image to response
logger.debug serial
system('sudo ocs-sr -g auto -ius -icrc -irhr -scr -icds -p command restoredisk scs_master3 sda')

if system('sudo mkdir /media/winos')
  if system('sudo mount -t ntfs -o remove_hiberfile /dev/sda4 /media/winos')
    if system('sudo cp /home/imaging/SCS/* /media/winos/SCS\\ Additional\\ Software/')
      logger.info 'Copied scripts successfully!'
    end
    system('sudo umount /dev/sda4')
  end
end

# Debugging, mostly
logger.debug serial

uri = URI.parse("#{base_url}/api/set_imaged?serial=#{serial}")
begin
  response = Net::HTTP.get_response(uri)
rescue Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
  logger.error e
  retry
end

if defined? response and response
  logger.info response

  15.downto(0) do |i|
    logger.info "Rebooting in #{'%02d' % i} seconds"
    sleep 1
  end
  system('reboot')
end


