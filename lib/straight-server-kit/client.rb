require 'faraday'

module StraightServerKit
  class Client

    DEFAULT_API_URL = 'http://localhost:9000'.freeze

    attr_reader :url, :resources

    def initialize(url: DEFAULT_API_URL)
      @url       = url
      @resources = {}
    end

    def pay_url(order)
      File.join(url, order.pay_path) if order.pay_path
    end

    def connection
      Faraday.new(connection_options) { |req|
        req.adapter :net_http
      }
    end

    def method_missing(name, *args, &block)
      if self.class.resources.keys.include?(name)
        resources[name] ||= self.class.resources[name].new(connection: connection)
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
        headers: {
          content_type: 'application/json',
        }
      }
    end
  end
end
