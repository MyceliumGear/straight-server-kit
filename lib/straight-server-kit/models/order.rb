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
    attribute :signature, String
    attribute :status, Integer
    attribute :tid, String

    def sign_with(secret)
      self.signature = StraightServerKit.sign(content: keychain_id.to_s, secret: secret)
    end

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
          property :signature
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
