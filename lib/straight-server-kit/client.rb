require 'faraday'

module StraightServerKit
  class Client

    DEFAULT_API_URL = 'http://localhost:9000'.freeze

    attr_reader :url, :resources, :gateway_id, :secret

    def initialize(gateway_id:, secret:, url: DEFAULT_API_URL)
      @gateway_id = gateway_id
      @secret     = secret
      @url        = url
      @resources  = {}
    end

    def pay_url(order)
      File.join(url, order.pay_path) if order.pay_path
    end

    def connection
      Faraday.new(connection_options) do |faraday|
        faraday.use SigningMiddleware, @secret
        faraday.adapter :net_http
      end
    end

    def method_missing(name, *args, &block)
      if self.class.resources.has_key?(name)
        resources[name] ||= self.class.resources[name].for_gateway(@gateway_id).new(connection: connection)
      else
        super
      end
    end

    def self.resources
      {
        orders: OrderResource,
      }
    end

    private def connection_options
      {
        url:     url,
        ssl:     {
          ca_path: ENV['SSL_CERT_DIR'] || '/etc/ssl/certs',
        },
        headers: {
          content_type: 'application/json',
        }
      }
    end

    class SigningMiddleware < Faraday::Middleware

      def initialize(app, secret)
        @app    = app
        @secret = secret
      end

      def call(env)
        env[:request_headers]['X-Nonce']     = nonce = (Time.now.to_f * 1e12).to_i.to_s
        env[:request_headers]['X-Signature'] = StraightServerKit.signature(
          nonce:       nonce,
          body:        env[:body],
          method:      env[:method],
          request_uri: URI(env[:url]).request_uri,
          secret:      @secret,
        )
        @app.call(env)
      end
    end
  end
end
