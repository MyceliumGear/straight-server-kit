require 'spec_helper'

RSpec.describe StraightServerKit::OrderResource do
  include_context 'resources'

  describe '#create' do
    it 'creates order' do
      @order = StraightServerKit::Order.new(amount: 1, callback_data: '123', keychain_id: 1)

      expect(@order.amount).to eq 1
      expect(@order.amount).to be_kind_of BigDecimal
      expect(@order.callback_data).to eq '123'
      expect(@order.keychain_id).to eq 1

      VCR.use_cassette 'orders_create' do
        @created_order = client.orders.create(@order)
      end

      expect(@created_order.address.to_s).not_to be_empty
      expect(@created_order.amount > 0).to eq true
      expect(@created_order.amount).to be_kind_of BigDecimal
      expect(@created_order.amount_in_btc > 0).to eq true
      expect(@created_order.amount_in_btc).to be_kind_of BigDecimal
      expect(@created_order.id > 0).to eq true
      expect(@created_order.keychain_id > 0).to eq true
      expect(@created_order.last_keychain_id > 0).to eq true
      expect(@created_order.payment_id.to_s).not_to be_empty
      expect(@created_order.status).to eq 0
      expect(@created_order.tid).to eq nil

      # orders.create never sets these fields
      expect(@created_order.callback_data).to eq nil

      $order_id   = @created_order.id
      $payment_id = @created_order.payment_id
    end

    it 'raises ApiError' do
      @order = StraightServerKit::Order.new(callback_data: '123', keychain_id: 1)
      VCR.use_cassette 'orders_create_invalid' do
        begin
          client.orders.create(@order)
        rescue => @error
        end
      end
      expect(@error).to be_instance_of StraightServerKit::ApiError
      expect(@error.status).to eq 409
      expect(@error.message).to eq "Invalid order: amount cannot be nil and should be more than 0"
    end
  end

  describe '#find' do
    it 'finds existing order by id' do
      VCR.use_cassette 'find_order_by_id' do
        @order = client.orders.find(id: $order_id)
      end
      expect(@order.id).to eq $order_id
    end

    it 'finds existing order by payment_id' do
      VCR.use_cassette 'find_order_by_payment_id' do
        @order = client.orders.find(id: $payment_id)
      end
      expect(@order.id).to eq $order_id
    end

    it 'raises ApiError when not found' do
      VCR.use_cassette 'find_order_fails' do
        begin
          @order = client.orders.find(id: 'meah')
        rescue => @error
        end
      end
      expect(@error).to be_instance_of StraightServerKit::ApiError
      expect(@error.status).to eq 404
      expect(@error.message).to end_with "Not found"
    end
  end

  describe '#cancel' do
    it "cancels new order" do
      VCR.use_cassette 'cancel_new_order' do
        @result = client.orders.cancel(id: $payment_id)
      end
      expect(@result).to eq true
    end
  end
end
