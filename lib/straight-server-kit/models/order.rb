module StraightServerKit
  class Order < BaseModel

    attribute :address, String
    attribute :amount, BigDecimal
    attribute :amount_in_btc, BigDecimal
    attribute :callback_data, String
    attribute :id, Integer
    attribute :keychain_id, Integer
    attribute :last_keychain_id, Integer
    attribute :payment_id, String
    attribute :status, Integer
    attribute :tid, String
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
          property :id
          property :keychain_id
          property :last_keychain_id
          property :payment_id
          property :status
          property :tid
        end
      end
    end
  end
end
