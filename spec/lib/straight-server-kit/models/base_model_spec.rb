require 'spec_helper'

RSpec.describe StraightServerKit::BaseModel do
  subject(:model) do
    Class.new(StraightServerKit::BaseModel) do |base|
      attribute :attribute

      def self.name
        'SomeModel'
      end
    end
  end

  describe '#inspect' do
    it 'is inspectable' do
      @instance = model.new(attribute: 5)
      expect(@instance.inspect).to eq '<SomeModel {:@attribute=>5}>'
    end
  end
end
