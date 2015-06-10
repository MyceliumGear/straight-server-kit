module StraightServerKit
  class ApiError < StandardError

    attr_reader :status

    def initialize(status:, message:)
      super(message)
      @status = status
    end
  end
end
