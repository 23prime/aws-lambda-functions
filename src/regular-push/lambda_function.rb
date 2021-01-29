require 'json'

BASE_URI = ENV.fetch('GOKABOT_BASE_URI', nil)

def lambda_handler(event:, context:)
  send_to_line('MY_USER_ID')
  send_to_line('NGA_GROUP_ID')
  send_to_line('KMT_GROUP_ID')
  send_to_discord
end

def send_to_line(target)
  return 500 if BASE_URI.nil?

  uri = URI.parse("#{BASE_URI}/line/push/random")
  params = { target: target }
  response = Net::HTTP.post_form(uri, params)
  return response.code
end

def send_to_discord
  return 500 if BASE_URI.nil?

  uri = URI.parse("#{BASE_URI}/discord/push/random")
  response = Net::HTTP.post_form(uri, {})
  return response.code
end
