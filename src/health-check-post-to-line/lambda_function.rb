require 'json'
require 'net/http'

require 'aws-sdk-ssm'

def lambda_handler(event)
  ssm_params = get_ssm_params
  token = ssm_params['token']
  target_ids = ssm_params['target_ids']

  target_ids.each do |id|
    send_request(event, token, id)
  end
end

def send_request(event, token, id)
  uri = URI.parse('https://api.line.me/v2/bot/message/push')

  headers = {
    'Content-type' => 'application/json',
    'Authorization' => "Bearer #{token}"
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

def get_ssm_params
  ssm = Aws::SSM::Client.new
  response = ssm.get_parameters(
    {
      names: ['gokabot.LINE_CHANNEL_TOKEN', 'gokabot.MY_USER_ID', 'gokabot.NGA_GROUP_ID'],
      with_decryption: true
    }
  )

  return {
    'token' => response.parameters[0].value,
    'target_ids' => [response.parameters[1].value, response.parameters[2].value]
  }
end
