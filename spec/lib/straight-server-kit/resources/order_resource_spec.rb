require 'spec_helper'

RSpec.describe StraightServerKit::OrderResource do
  include_context 'resources'
  subject(:resource) { described_class.new(connection: connection) }

  describe '#create' do
    it 'creates order' do
      @order = StraightServerKit::Order.new(amount: 0.01, callback_data: '123', keychain_id: 1)
      @order.sign_with gateway_secret

      expect(@order.amount).to eq 0.01
      expect(@order.amount).to be_kind_of BigDecimal
      expect(@order.callback_data).to eq '123'
      expect(@order.keychain_id).to eq 1
      expect(@order.signature).to eq '1d295e79be14197cea096afbcd898267aebaa93d6e6973227132ff35d5f64147'

      VCR.use_cassette 'orders_create' do
        @created_order = client.orders.create(@order, gateway_id: gateway_id)
      end

      expect(@created_order.address).to eq '1EvNEJtVFuoGdGRMSKsDALxaZy5q66B2qq'
      expect(@created_order.amount).to eq 4382
      expect(@created_order.amount).to be_kind_of BigDecimal
      expect(@created_order.amount_in_btc).to eq 0.00004382
      expect(@created_order.amount_in_btc).to be_kind_of BigDecimal
      expect(@created_order.id).to eq 15
      expect(@created_order.keychain_id).to eq 1
      expect(@created_order.last_keychain_id).to eq 1
      expect(@created_order.payment_id).to eq '5d010bd6d45ec67ccd8d3c63dfdf038bd6310f89ed2b657d42b1831e551bc2fe'
      expect(@created_order.status).to eq 0
      expect(@created_order.tid).to eq nil

      # orders.create never sets these fields
      expect(@created_order.callback_data).to eq nil
      expect(@created_order.signature).to eq nil
    end

    it 'raises ApiError' do
      @order = StraightServerKit::Order.new(amount: 0.01, callback_data: '123', keychain_id: 1)
      VCR.use_cassette 'orders_create_unsigned' do
        begin
          client.orders.create(@order, gateway_id: gateway_id)
        rescue => @error
        end
      end
      expect(@error).to be_instance_of StraightServerKit::ApiError
      expect(@error.status).to eq 409
      expect(@error.message).to start_with "Invalid signature"
    end
  end

  describe '#find' do
    it 'finds existing order by id' do
      VCR.use_cassette 'find_order_by_id' do
        @order = client.orders.find(id: 15, gateway_id: gateway_id)
      end
      expect(@order.id).to eq 15
    end

    it 'finds existing order by payment_id' do
      VCR.use_cassette 'find_order_by_payment_id' do
        @order = client.orders.find(id: '5d010bd6d45ec67ccd8d3c63dfdf038bd6310f89ed2b657d42b1831e551bc2fe', gateway_id: gateway_id)
      end
      expect(@order.id).to eq 15
    end

    it 'raises ApiError when not found' do
      VCR.use_cassette 'find_order_fails' do
        begin
          @order = client.orders.find(id: 'meah', gateway_id: gateway_id)
        rescue => @error
        end
      end
      expect(@error).to be_instance_of StraightServerKit::ApiError
      expect(@error.status).to eq 404
      expect(@error.message).to end_with "Not found"
    end
  end
end
