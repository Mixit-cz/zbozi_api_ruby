# ZboziApiRuby
[![Build Status](https://www.travis-ci.org/Mixit-cz/zbozi_api_ruby.svg?branch=master)](https://www.travis-ci.org/Mixit-cz/zbozi_api_ruby)[![Maintainability](https://api.codeclimate.com/v1/badges/0966264451aa3fd9d281/maintainability)](https://codeclimate.com/github/Mixit-cz/zbozi_api_ruby/maintainability)[![Test Coverage](https://api.codeclimate.com/v1/badges/0966264451aa3fd9d281/test_coverage)](https://codeclimate.com/github/Mixit-cz/zbozi_api_ruby/test_coverage)

This Ruby client library for the [Slevomat Zbozi API](https://www.slevomat.cz/partner/zbozi-api#komunikace-partner-slevomat). It provides an easy way to interact with the Slevomat Zbozi API in any kind of application.

## Installation

Add this line to your application's Gemfile: **not yet released, point to github master**

```ruby
gem 'zbozi_api_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zbozi_api_ruby

## Usage

### Basic usage

The gem uses a client model to query against the API. You create and configure a client with your API keys and make requests through that.

```
require 'zbozi_api_ruby'

client = ZboziApiRuby::Client.new({
  api_secret: YOUR_SECRET,
  token: YOUR_TOKEN,
})

client.mark_pending(12345)
```

Alternatively, you can also globally configure the client using a configure
block, and access a client singleton using `ZboziApiRuby.client`.  If you intend to
use the gem with Rails, the client should be configured in an initializer.

```
require 'zbozi_api_ruby'

ZboziApiRuby.client.configure do |config|
  config.api_secret = YOUR_SECRET
  config.token = YOUR_TOKEN
end

ZboziApiRuby.client.mark_pending(12345)
```

After creating the client you're able to make requests to the API.

### [Cancel](https://www.slevomat.cz/partner/zbozi-api#vytvoreni-storna) example

Once you have a client you can use ``#cancel`` to make a request to the [Cancel API](https://www.slevomat.cz/partner/zbozi-api#vytvoreni-storna).

For cancel, you need to pass in params to the method as hashes:

```
params = {
    items: [
        {
            slevomatId: '45454',
            amount: 15
        }
    ],
    note: 'optional note'
}

client.cancel(12345, params)
```

On successful response you will receive `ZboziApiRuby::Response::Cancel`. Error will be raised otherwise.

### Other endpoints
`ZboziApiRuby` client wraps around all endpoints described in [official docs](https://www.slevomat.cz/partner/zbozi-api#komunikace-partner-slevomat):

- cancel
- mark delivered
- mark en route
- mark getting ready for pickup
- mark pending
- mark ready for pickup
- update shipping address

### Returned data

Some methods return values, eg. `mark_en_route` should return `{"expectedDeliveryDate": "2018-03-09"}` in it's raw response from API.

In this example, you are able to get it via client's `response` (`ZboziApiRuby::Response::MarkEnRoute`) with `response.expected_delivery_date`. The value will be identical to raw data from API, so in this case string like `"2018-03-09"`.

Client will do the similar change (`expectedDeliveryDate -> expected_delivery_date`) for all expected return values.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

If you change vcr casettes, do not forget to edit out your API secrets from them.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Mixit-cz/zbozi_api_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

### How to contribute
1. Fork it ( https://github.com/Mixit-cz/zbozi_api_ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ZboziApiRuby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Mixit-cz/zbozi_api_ruby/blob/master/CODE_OF_CONDUCT.md).
