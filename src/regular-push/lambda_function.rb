require 'json'

BASE_URI = ENV['GOKABOT_BASE_URI']

def lambda_handler(event:, context:)
  send_to_line('MY_USER_ID')
  send_to_line('NGA_GROUP_ID')
  send_to_line('KMT_GROUP_ID')
  send_to_discord(ENV['DISCORD_TARGET_CHANNEL_ID'])
end

def send_to_line(target_id)
  return 500 if BASE_URI.nil?

  uri = URI.parse("#{BASE_URI}/line/push/random")
  headers = { 'Content-Type' => 'application/json' }
  params = { 'target_id' => target_id }

  response = Net::HTTP.post(uri, params.to_json, headers)
  return response.code
end

def send_to_discord(target_id)
  return 500 if BASE_URI.nil?

  uri = URI.parse("#{BASE_URI}/discord/push/random")
  headers = { 'Content-Type' => 'application/json' }
  params = { 'target_id' => target_id }

  response = Net::HTTP.post(uri, params.to_json, headers)
  return response.code
end
