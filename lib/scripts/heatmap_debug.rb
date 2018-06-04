require 'json'
require 'net/http'
require 'uri'
require 'logger'

logger = Logger.new(STDOUT)

# Set machine serial number
base_url = ENV['url_debug']
serial = `echo '5CD820DZZ2' | sed 's/.*: //g'`.strip!

# Checks if the machine is imaged
uri = URI.parse("#{base_url}/api/check_imaged?serial=#{serial}")
begin
  response = Net::HTTP.get_response(uri)
rescue Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
  logger.error e
  retry
end

if response
  # Parses API response
  body = JSON.parse(response.body)

  # Checks if the API returns that the machine is imaged
  if body['imaged']
    logger.info 'If you would like to manually re-image, run `ruby imaging.rb` at the prompt'
    Kernel.exit(0)
  end

  system('ruby imaging.rb')
else
  logger.error 'Response Invalid'
end