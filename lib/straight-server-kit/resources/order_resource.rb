module StraightServerKit
  class OrderResource < ResourceKit::Resource

    API_ERROR_HANDLER = proc do |response|
      raise ApiError.new(status: response.status, message: response.body)
    end

    def self.for_gateway(gateway_id)
      name = "OrderResource_#{gateway_id.to_s.to_sym.object_id}"
      return StraightServerKit.const_get(name) if StraightServerKit.const_defined?(name)
      klass = Class.new self do
        resources do
          action :create do
            verb :post
            path "/gateways/#{gateway_id}/orders"
            body do |order|
              Order::Mapping.representation_for(:create, order, Order::Dumper)
            end
            handler 200 do |response|
              Order::Mapping.extract_single(response.body, :created)
            end
            handler &API_ERROR_HANDLER
          end

          action :find do
            verb :get
            path "/gateways/#{gateway_id}/orders/:id"
            handler 200 do |response|
              Order::Mapping.extract_single(response.body, :found)
            end
            handler &API_ERROR_HANDLER
          end

          action :cancel do
            verb :post
            path "/gateways/#{gateway_id}/orders/:id/cancel"
            handler 204 do
              true
            end
            handler &API_ERROR_HANDLER
          end
        end
      end
      StraightServerKit.const_set name, klass
    end
  end
end
