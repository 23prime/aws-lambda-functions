require 'spec_helper'

describe 'regular-push' do
  context 'LINE' do
    it 'Correct request' do
      expect(send_to_line('MY_USER_ID')).to eq '200'
    end
  end

  context 'Discord' do
    it 'Correct request' do
      expect(send_to_discord).to eq '200'
    end
  end
end
