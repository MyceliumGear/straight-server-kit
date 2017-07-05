module StraightServerKit
  class Order < BaseModel

    # https://github.com/MyceliumGear/straight/blob/master/lib/straight/order.rb#L52
    STATUS = {
      new:             0, # no transactions detected
      unconfirmed:     1, # transaction detected, but doesn't have enough confirmations
      paid:            2, # transaction detected with the required confirmations number and the correct amount
      underpaid:       3, # amount_paid is less than amount
      overpaid:        4, # amount_paid is more than amount
      expired:         5, # no transaction detected during order's expiration period
      canceled:        6, # order cancelled without payment
      partially_paid: -3, # becomes paid/overpaid if additional transaction detected or underpaid after order expiration
    }

    attribute :address, String
    attribute :amount, BigDecimal
    attribute :amount_in_btc, BigDecimal
    attribute :amount_paid_in_btc, BigDecimal
    attribute :amount_to_pay_in_btc, BigDecimal
    attribute :callback_data, String
    attribute :id, Integer
    attribute :keychain_id, Integer
    attribute :last_keychain_id, Integer
    attribute :payment_id, String
    attribute :status, Integer
    attribute :tid, String # @deprecated
    attribute :transaction_ids, Array[String]
    attribute :currency, String
    attribute :description, String
    attribute :auto_redirect, Boolean
    attribute :after_payment_redirect_to, String

    def pay_path
      "/pay/#{payment_id}" if payment_id
    end

    class Mapping
      include Kartograph::DSL

      kartograph do
        mapping Order
        scoped :create do
          property :amount
          property :callback_data
          property :keychain_id
          property :currency
          property :description
          property :auto_redirect
          property :after_payment_redirect_to
        end
        scoped :created, :found do
          property :address
          property :amount
          property :amount_in_btc
          property :amount_paid_in_btc
          property :amount_to_pay_in_btc
          property :id
          property :keychain_id
          property :last_keychain_id
          property :payment_id
          property :status
          property :tid # @deprecated
          property :transaction_ids
        end
      end
    end

    class Dumper

      def self.dump(obj)
        new_obj = obj.reject { |_k, v| v.nil? }
        JSON.dump(new_obj)
      end
    end
  end
end
