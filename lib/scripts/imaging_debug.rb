require 'json'
require 'net/http'
require 'uri'

serial = '5C382060F6'
base_url = 'http://localhost:3000'
puts "Starting imaging on #{serial}"

#Request image from server and set image to response
puts serial

uri = URI.parse("#{base_url}/api/set_imaged?serial=#{serial}")
begin
  Net::HTTP.get_response(uri)
rescue Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError
  retry
end


puts 'Reboot'