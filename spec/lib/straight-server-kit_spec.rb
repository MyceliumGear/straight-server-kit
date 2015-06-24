require 'spec_helper'

RSpec.describe StraightServerKit do
  it "validates signature" do
    secret      = 'secret'
    request_uri = '/callback/path?order_id=1&callback_data=test'
    signature   = described_class.signature(nonce: nil, body: nil, method: 'GET', request_uri: request_uri, secret: secret)
    expect(described_class.valid_callback?(signature: nil, request_uri: request_uri, secret: nil)).to eq false
    expect(described_class.valid_callback?(signature: nil, request_uri: request_uri, secret: secret)).to eq false
    expect(described_class.valid_callback?(signature: signature, request_uri: request_uri, secret: nil)).to eq false
    expect(described_class.valid_callback?(signature: signature, request_uri: request_uri, secret: secret)).to eq true
    expect(described_class.valid_signature?(signature: signature, request_uri: request_uri, secret: secret, nonce: nil, body: nil, method: 'GET')).to eq true
  end
end
