require 'json'
require 'net/http'
require 'uri'

#get machine serial number
serial = '5C382060F6'
base_url = 'http://localhost:3000'

# Checks if the machine is imaged
uri = URI.parse("#{base_url}/api/check_imaged?serial=#{serial}")
begin
  response = Net::HTTP.get_response(uri)
rescue Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError
  retry
end

if response
  # Parses API response
  body = JSON.parse(response.body)

  # Checks if the API returns that the machine is imaged
  if body['imaged']
    puts 'If you would like to manually re-image, run `ruby imaging.rb` at the prompt'
    Kernel.exit(0)
  end

  system('ruby imaging.rb')
else
  puts 'Response Invalid'
end