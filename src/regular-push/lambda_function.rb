require 'json'

def lambda_handler(event:, context:)
  send_push_msg('MY_USER_ID')
  send_push_msg('NGA_GROUP_ID')
  send_push_msg('KMT_GROUP_ID')
end

def send_push_msg(target)
  uri = URI.parse('https://gokabot.com/gokabot-line-dev/push/random')
  params = { target: target }
  response = Net::HTTP.post_form(uri, params)
  return response.code
end
