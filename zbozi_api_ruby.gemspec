
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "zbozi_api_ruby/version"

Gem::Specification.new do |spec|
  spec.name          = "zbozi_api_ruby"
  spec.version       = ZboziApiRuby::VERSION
  spec.authors       = ["Jan Hovancik"]
  spec.email         = ["conta.srdr@gmail.com"]

  spec.summary       = %q{ Ruby client library for the Slevomat Zbozi API }
  spec.description   = %q{ Provides an easy way to interact with the Slevomat Zbozi API in any kind of application }
  spec.homepage      = "https://github.com/Mixit-cz/zbozi_api_ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "vcr", "~> 4.0"
  spec.add_development_dependency "webmock", "~> 3.3"
  spec.add_development_dependency "pry", "~> 0.10.3"
  spec.add_development_dependency "dotenv", "~> 2.2", ">= 2.2.1"
  spec.add_development_dependency "simplecov", "~> 0.12.0"

  spec.add_runtime_dependency "faraday", "~> 0.14", ">= 0.14.0"
  spec.add_runtime_dependency "faraday_middleware", "~> 0.12.2"
end
