require 'json'
require 'net/http'
require 'uri'
require 'highline/import'

#serial = `sudo dmidecode -t 1 | grep Serial | sed 's/.*: //g'`.chomp
serial = '5C382060F6'

uri = URI.parse("http://localhost:3000/api/check_imaged?serial=#{serial}")
begin
  response = Net::HTTP.get_response(uri)
rescue
  retry
end

body = JSON.parse(response.body)

if body['imaged']
  confirm = ask("Re-image machine? [Y/N] ") {|yn| yn.limit = 1, yn.validate = /[yn]/i}

  if confirm.downcase != 'y'
    Kernel.exit(false)
  end
end

puts 'Continuing with imaging'

uri = URI.parse("http://localhost:3000/api/set_imaged?serial=#{serial}")
begin
  response = Net::HTTP.get_response(uri)
rescue
  retry
end
