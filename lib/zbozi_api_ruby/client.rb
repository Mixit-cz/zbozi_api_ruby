require 'faraday'
require 'faraday_middleware'

require 'zbozi_api_ruby/configuration'
require 'zbozi_api_ruby/error'
require 'zbozi_api_ruby/endpoint/cancel'
require 'zbozi_api_ruby/endpoint/mark_pending'
require 'zbozi_api_ruby/endpoint/mark_en_route'
require 'zbozi_api_ruby/endpoint/mark_getting_ready_for_pickup'
require 'zbozi_api_ruby/endpoint/mark_ready_for_pickup'
require 'zbozi_api_ruby/endpoint/mark_delivered'
require 'zbozi_api_ruby/endpoint/update_shipping_address'

module ZboziApiRuby
  class Client
    API_HOST  = 'https://www.slevomat.cz/'.freeze

    REQUEST_CLASSES = [
      ZboziApiRuby::Endpoint::Cancel,
      ZboziApiRuby::Endpoint::MarkPending,
      ZboziApiRuby::Endpoint::MarkEnRoute,
      ZboziApiRuby::Endpoint::MarkGettingReadyForPickup,
      ZboziApiRuby::Endpoint::MarkReadyForPickup,
      ZboziApiRuby::Endpoint::MarkDelivered,
      ZboziApiRuby::Endpoint::UpdateShippingAddress
    ]

    attr_reader :configuration

    # Creates an instance of the ZboziApiRuby client
    # @param options [Hash, nil] a hash of the token and api_secret
    # @return [Client] a new client initialized with the keys
    def initialize(options = nil)
      @configuration = nil
      define_request_methods

      unless options.nil?
        @configuration = Configuration.new(options)
        check_api_keys
      end
    end

    # Configure the API client
    # @yield [Configuration] a configuration object
    # @raise [MissingAPIKeys] if the configuration is invalid
    # @example Simple configuration
    #   ZboziApiRuby::Client.client.configure do |config|
    #     config.token = 'abc'
    #     config.api_secret = 'def'
    #   end
    def configure
      raise Error::AlreadyConfigured unless @configuration.nil?

      @configuration = Configuration.new
      yield(@configuration)
      check_api_keys
    end

    # Checks that all the keys needed were given
    def check_api_keys
      if configuration.nil? || !configuration.valid?
        @configuration = nil
        raise Error::MissingAPIKeys
      else
        # Freeze the configuration so it cannot be modified once the gem is
        # configured.  This prevents the configuration changing while the gem
        # is operating, which would necessitate invalidating various caches.
        @configuration.freeze
      end
    end

    # API connection
    def connection
      return @connection if instance_variable_defined?(:@connection)

      check_api_keys
      headers = {
        'X-PartnerToken': @configuration.token,
        'X-ApiSecret': @configuration.api_secret
      }
      @connection = Faraday.new(url: API_HOST, headers: headers) do |conn|
        conn.request  :json
        conn.response :logger                  # log requests to STDOUT
        conn.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    # String to be used in API paths to specify whether we are on testing endpoint
    #   https://www.slevomat.cz/partner/zbozi-api#testovaci-rozhrani_1
    def endpoint_version
      return 'v1-test' if is_test?
      'v1'
    end

    private

    # This goes through each endpoint class and creates singletone methods
    # on the client that query those classes. We do this to avoid possible
    # namespace collisions in the future when adding new classes
    def define_request_methods
      REQUEST_CLASSES.each do |request_class|
        endpoint_instance = request_class.new(self)
        create_methods_from_instance(endpoint_instance)
      end
    end

    # Loop through all of the endpoint instances' public singleton methods to
    # add the method to client
    def create_methods_from_instance(instance)
      instance.public_methods(false).each do |method_name|
        add_method(instance, method_name)
      end
    end

    # Define the method on the client and send it to the endpoint instance
    # with the args passed in
    def add_method(instance, method_name)
      define_singleton_method(method_name) do |*args|
        instance.public_send(method_name, *args)
      end
    end

    # Returns whether we are on test endpoint
    def is_test?
      @configuration && @configuration.is_test?
    end
  end
end
