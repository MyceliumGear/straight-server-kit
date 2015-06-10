require 'spec_helper'

RSpec.describe StraightServerKit::Order do

  it "constructs pay path" do
    @order = described_class.new
    expect(@order.pay_path).to eq nil
    @order.payment_id = 'abc'
    expect(@order.pay_path).to eq '/pay/abc'
    @order.payment_id = 123
    expect(@order.pay_path).to eq '/pay/123'
  end
end
