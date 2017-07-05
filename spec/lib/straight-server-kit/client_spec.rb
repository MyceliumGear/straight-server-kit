require 'spec_helper'

RSpec.describe StraightServerKit::Client do

  let(:default_params) { {gateway_id: 1, secret: '0'} }
  subject(:client) { described_class.new(**default_params) }

  it "must be initialized with gateway_id and secret" do
    expect { StraightServerKit::Client.new }.to raise_error ArgumentError
    expect { StraightServerKit::Client.new(gateway_id: 1) }.to raise_error ArgumentError
    expect(subject.gateway_id).to eq 1
    expect(subject.secret).to eq '0'
  end

  it "can be initializes with an url" do
    expect(described_class::DEFAULT_API_URL).to eq 'https://gateway.gear.mycelium.com'
    expect(subject.url).to eq described_class::DEFAULT_API_URL

    client = StraightServerKit::Client.new(url: 'http://example.com', **default_params)
    expect(client.url).to eq 'http://example.com'
  end

  it "constructs pay url" do
    order = StraightServerKit::Order.new(payment_id: 'abc')
    expect(subject.pay_url(order)).to eq(described_class::DEFAULT_API_URL + '/pay/abc')
  end

  it "does respond to valid resources" do
    expect { client.orders }.to_not raise_error
  end

  it "does not respond to invalid resources" do
    expect { client.apples }.to raise_error NoMethodError
  end

  it "sets the content type" do
    expect(client.connection.headers['Content-Type']).to eq 'application/json'
  end
end
