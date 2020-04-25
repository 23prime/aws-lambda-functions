require 'spec_helper'

describe 'regular-push' do
  it 'Correct request' do
    expect(send_push_msg('MY_USER_ID')).to eq '200'
  end
end
