require 'json'
require 'net/http'

require 'aws-sdk-ssm'

def lambda_handler(event:, context:)
  message = parse_event(event)
  puts message
  send_to_line("#### From AWS/SNS #### \n#{message}")
end

def parse_event(event)
  puts event

  begin
    sns_record = event['Records'][0]['Sns']

    timestamp = sns_record['Timestamp']
    subject = sns_record['Subject']
    message = sns_record['Message']

    return "[Date]\n#{timestamp}\n\n[Subject]\n#{subject}\n\n[Message]\n#{message}"
  rescue StandardError => e
    puts e.message
    return 'Invalid event.'
  end
end

def send_to_line(message)
  ssm_params = get_ssm_params

  uri = URI.parse('https://api.line.me/v2/bot/message/push')

  headers = {
    'Content-type' => 'application/json',
    'Authorization' => "Bearer #{ssm_params['line_channel_token']}"
  }

  params = {
    'to' => ssm_params['target_id'],
    'messages' => [
      {
        'type' => 'text',
        'text' => message
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
      names: ['gokabot.LINE_CHANNEL_TOKEN', 'gokabot.MY_USER_ID'],
      with_decryption: true
    }
  )

  return {
    'line_channel_token' => response.parameters[0].value,
    'target_id' => response.parameters[1].value
  }
end
