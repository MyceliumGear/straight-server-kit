require 'straight-server-kit/version'
require 'resource_kit'
require 'kartograph'
require 'openssl'

module StraightServerKit
  autoload :Client, File.expand_path('../straight-server-kit/client', __FILE__)

  # Models
  autoload :BaseModel, File.expand_path('../straight-server-kit/models/base_model', __FILE__)
  autoload :ApiError, File.expand_path('../straight-server-kit/models/api_error', __FILE__)
  autoload :Order, File.expand_path('../straight-server-kit/models/order', __FILE__)

  # Resources
  autoload :OrderResource, File.expand_path('../straight-server-kit/resources/order_resource', __FILE__)

  # @param [String] signature X-Signature header
  # @param [String] request_uri /full/callback_path/with?order&callback_data
  # @param [String] secret gateway secret
  def self.valid_callback?(signature:, request_uri:, secret:)
    signature == self.signature(nonce: nil, body: nil, method: 'GET', request_uri: request_uri, secret: secret)
  end

  def self.valid_signature?(signature:, **args)
    signature == self.signature(**args)
  end

  def self.signature(nonce:, body:, method:, request_uri:, secret:)
    sha512  = OpenSSL::Digest::SHA512.new
    request = "#{method.to_s.upcase}#{request_uri}#{sha512.digest("#{nonce}#{body}")}"
    Base64.strict_encode64 OpenSSL::HMAC.digest(sha512, secret.to_s, request)
  end
end
