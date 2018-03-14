require "zbozi_api_ruby/version"
require 'zbozi_api_ruby/client'

module ZboziApiRuby
  # Returns an initially-unconfigured instance of the client.
  # @return [Client] an instance of the client
  #
  # @example Configuring and using the client
  #   ZboziApiRuby.client.configure do |config|
  #     config.token = 'abc'
  #     config.api_secret = 'def'
  #   end
  #
  #   ZboziApiRuby.client.search('San Francisco', { term: 'food' })
  #
  def self.client
    @client ||= ZboziApiRuby::Client.new
  end
end
