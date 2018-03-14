module ZboziApiRuby
  module Error
    # Validates ZboziApiRuby API responses.  This class shouldn't be used directly, but
    # should be accessed through the ZboziApiRuby::Error.check_for_error interface.
    # @see check_for_error
    class ResponseValidator

      # If the request is not successful, raise an appropriate ZboziApiRuby::Error
      # exception with the error text from the request response.
      # @param response from the ZboziApiRuby API
      def validate(response)
        return if successful_response?(response)
        raise error_from_response(response)
      end

      private

      def successful_response?(response)
        # Check if the status is in the range of non-error status codes
        (200..399).include?(response.status)
      end

      # Create an initialized exception from the response
      # @return [ZboziApiRuby::Error::Base] exception corresponding to API error
      def error_from_response(response)
        body = JSON.parse(response.body)
        klass = error_classes[status_to_error(body['status'])]
        klass.new(body['messages'].join(', '), status_to_error(body['status']))
      end

      # Maps from API Errors to ZboziApiRuby::Error exception classes.
      def error_classes
        @@error_classes ||= Hash.new do |hash, key|
          class_name = key
          hash[key] = ZboziApiRuby::Error.const_get(class_name)
        end
      end

      # Helper method for #error_classes
      # https://www.slevomat.cz/partner/zbozi-api#chybove-stavy
      def status_to_error(status)
        case status
        when 1
          'InvalidRequest'
        when 2
          'InvalidCredentials'
        when 3
          'NonExistentOrder'
        when 4
          'NonExistentOrderItem'
        when 5
          'InvalidStateChange'
        when 6
          'InvalidStorno'
        when 7
          'AnotherError'
        when 8
          'OrderNotExported'
        when 9
          'AutomaticDeliveryError'
        end
      end
    end

    # Check the response for errors, raising an appropriate exception if
    # necessary
    # @param (see ResponseValidator#validate)
    def self.check_for_error(response)
      @response_validator ||= ResponseValidator.new
      @response_validator.validate(response)
    end

    class Base < StandardError
      def initialize(msg,error=nil)
        super(msg)
      end
    end

    class AlreadyConfigured < Base
      def initialize(msg = 'Gem cannot be reconfigured.  Initialize a new ' +
          'instance of ZboziApiRuby::Client.', error=nil)
        super
      end
    end

    class MissingAPIKeys < Base
      def initialize(msg = "You're missing an API key", error=nil)
        super
      end
    end

    class InvalidRequest < Base; end
    class InvalidCredentials < Base; end
    class NonExistentOrder < Base; end
    class NonExistentOrderItem < Base; end
    class InvalidStateChange < Base; end
    class InvalidStorno < Base; end
    class AnotherError < Base; end
    class OrderNotExported < Base; end
    class AutomaticDeliveryError < Base; end
  end
end
