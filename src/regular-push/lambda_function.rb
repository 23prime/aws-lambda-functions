require 'json'

def lambda_handler(event:, context:)
  send_push_msg('MY_USER_ID')
  send_push_msg('NGA_GROUP_ID')
  send_push_msg('KMT_GROUP_ID')
end

def send_push_msg(target)
  base_uri = ENV.fetch('GOKABOT_BASE_URI', nil)

  return 500 if base_uri.nil?

  uri = URI.parse(base_uri + '/line/push/random')
  params = { target: target }
  response = Net::HTTP.post_form(uri, params)
  return response.code
end
