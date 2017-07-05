require 'spec_helper'

RSpec.describe StraightServerKit::Order do

  let (:order) { described_class.new }

  it "constructs pay path" do
    expect(order.pay_path).to eq nil
    order.payment_id = 'abc'
    expect(order.pay_path).to eq '/pay/abc'
    order.payment_id = 123
    expect(order.pay_path).to eq '/pay/123'
  end

  it "skips empty params from json" do
    json = order.class::Mapping.representation_for(:create, order, order.class::Dumper)
    expect(json).to eq %({})

    order.amount = 1
    json = order.class::Mapping.representation_for(:create, order, order.class::Dumper)
    expect([%({"amount":"0.1E1"}), %({"amount":"0.1e1"})]).to include json
  end

  it "humanizes order statuses" do
    expect(described_class::STATUS.keys.size).to eq 8
  end
end
