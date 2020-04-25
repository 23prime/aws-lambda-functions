require 'dotenv/load'
require 'json'
require 'net/http'

def lambda_handler(event:, context:)
  send_request(event, ENV.fetch('MY_USER_ID', ''))
  send_request(event, ENV.fetch('NGA_GROUP_ID', 'MY_USER_ID'))
end

def send_request(event, id)
  uri = URI.parse('https://api.line.me/v2/bot/message/push')

  headers = {
    'Content-type' => 'application/json',
    'Authorization' => 'Bearer ' + ENV.fetch('LINE_CHANNEL_TOKEN', '')
  }

  params = {
    'to' => id,
    'messages' => [
      {
        'type' => 'text',
        'text' => JSON.pretty_generate(event)
      }
    ]
  }.to_json

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme === 'https'
  response = http.post(uri.path, params, headers)

  return response.code
end
