module ZboziApiRuby
  class Configuration
    AUTH_KEYS = [:token, :api_secret]

    attr_accessor *AUTH_KEYS, :test

    # Creates the configuration
    # @param [Hash] hash containing configuration parameters and their values
    # @return [Configuration] a new configuration with the values from the
    #   config_hash set
    def initialize(config_hash = nil)
      if config_hash.is_a?(Hash)
        config_hash.each do |config_name, config_value|
          self.send("#{config_name}=", config_value)
        end
      end
    end

    # Returns a hash of api keys and their values
    def auth_keys
      AUTH_KEYS.inject({}) do |keys_hash, key|
        keys_hash[key] = send(key)
        keys_hash
      end
    end

    def valid?
      AUTH_KEYS.none?{ |key| send(key).nil? || send(key).empty? }
    end

    def is_test?
      !!test
    end
  end
end
