require 'spec_helper'

RSpec.describe StraightServerKit do
  it "validates callback signature" do
    secret    = 'secret'
    signature = described_class.sign(content: 1, secret: secret)
    expect(described_class.valid_callback?({}, secret)).to eq false
    expect(described_class.valid_callback?({signature: 'asdf'}, secret)).to eq false
    expect(described_class.valid_callback?({order_id: 1}, secret)).to eq false
    expect(described_class.valid_callback?({order_id: 1, signature: signature}, secret)).to eq true
  end
end
