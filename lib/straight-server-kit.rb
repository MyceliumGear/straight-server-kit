require 'straight-server-kit/version'
require 'resource_kit'
require 'kartograph'

module StraightServerKit
  autoload :Client, File.expand_path('../straight-server-kit/client', __FILE__)

  # Models
  autoload :BaseModel, File.expand_path('../straight-server-kit/models/base_model', __FILE__)
  autoload :ApiError, File.expand_path('../straight-server-kit/models/api_error', __FILE__)
  autoload :Order, File.expand_path('../straight-server-kit/models/order', __FILE__)

  # Resources
  autoload :OrderResource, File.expand_path('../straight-server-kit/resources/order_resource', __FILE__)

  def self.valid_callback?(params, secret)
    return false unless params[:signature] && params[:order_id]
    sign(content: params[:order_id], secret: secret) == params[:signature]
  end

  def self.sign(content:, secret:, level: 1)
    return unless secret
    result = content.to_s
    level.times do
      result = OpenSSL::HMAC.hexdigest('sha256', secret.to_s, result)
    end
    result
  end
end
