require 'json'
require 'net/http'
require 'uri'
require 'logger'

logger = Logger.new(STDOUT)

base_url = ENV['url_debug']
serial = `echo '5CD820DZZ2' | sed 's/.*: //g'`.strip!

logger.info "Starting imaging on #{serial}"

# Request image from server and set image to response
logger.debug serial
logger.debug 'This is where we are imaging'

# Debugging, mostly
logger.debug serial

uri = URI.parse("#{base_url}/api/set_imaged?serial=#{serial}")
begin
  Net::HTTP.get_response(uri)
rescue Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
  logger.error e
  retry
end

15.downto(0) do |i|
  logger.info "Rebooting in #{'%02d' % i} seconds"
  sleep 1
end
logger.debug 'rebooting'