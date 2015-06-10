module StraightServerKit
  class OrderResource < ResourceKit::Resource

    API_ERROR_HANDLER = lambda do |response|
      raise ApiError.new(status: response.status, message: response.body)
    end

    resources do
      action :create do
        verb :post
        path '/gateways/:gateway_id/orders'
        body do |order|
          Order::Mapping.representation_for(:create, order)
        end
        handler 200 do |response|
          Order::Mapping.extract_single(response.body, :created)
        end
        handler &API_ERROR_HANDLER
      end

      action :find do
        verb :get
        path '/gateways/:gateway_id/orders/:id'
        handler 200 do |response|
          Order::Mapping.extract_single(response.body, :found)
        end
        handler &API_ERROR_HANDLER
      end
    end
  end
end
