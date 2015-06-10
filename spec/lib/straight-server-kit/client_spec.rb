require 'spec_helper'

RSpec.describe StraightServerKit::Client do
  subject(:client) { StraightServerKit::Client.new }

  it "can be initializes with an url" do
    @client = StraightServerKit::Client.new(url: 'http://gear.loc')
    expect(@client.url).to eq 'http://gear.loc'
  end

  it "constructs pay url" do
    @order = StraightServerKit::Order.new(payment_id: 'abc')
    expect(described_class.new.pay_url(@order)).to eq 'http://localhost:9000/pay/abc'
    expect(described_class.new(url: 'https://gear.loc').pay_url(@order)).to eq 'https://gear.loc/pay/abc'
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
