require 'json'
require 'net/http'
require 'uri'
require 'logger'

logger = Logger.new(STDOUT)

#get machine serial number
serial = `sudo dmidecode -t 1 | grep Serial | sed 's/.*: //g'`.strip!
base_url = 'http://10.0.2.7:3001'

# Checks if the machine is imaged
uri = URI.parse("#{base_url}/api/check_imaged?serial=#{serial}")

logger.info uri

begin
  response = Net::HTTP.get_response(uri)
rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
    Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
  logger.error e
  retry
end

if defined? response
  # Parses API response
  body = JSON.parse(response.body)

  logger.info body
  # Checks if the API returns that the machine is imaged
  if body['imaged']
    logger.info 'If you would like to manually re-image, run `ruby imaging.rb` at the prompt'
    Kernel.exit(0)
  end

  system('ruby imaging.rb')
else
  logger.error 'Response Invalid'
end
