require 'spec_helper'

describe 'health-check-post-to-line' do
  let(:event) {
    {
      'id' => 'cdc73f9d-aea9-11e3-9d5a-835b769c0d9c',
      'detail-type' => 'Scheduled Event',
      'source' => 'aws.events',
      'account' => '{{{account-id}}}',
      'time' => '1970-01-01T00:00:00Z',
      'region' => 'ap-northeast-1',
      'resources' => [
        'arn:aws:events:ap-northeast-1:123456789012:rule/ExampleRule'
      ],
      'detail' => {}
    }
  }

  it 'Correct request' do
    expect(send_request(event, ENV.fetch('MY_USER_ID'))).to eq '200'
  end
end
