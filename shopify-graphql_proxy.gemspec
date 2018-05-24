# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "shopify-graphql_proxy"
  spec.version       = "0.1.0"
  spec.authors       = ["montalvomiguelo"]
  spec.email         = ["me@montalvomiguelo.com"]

  spec.summary       = %q{Securely proxying graphql requests from our app to shopify}
  spec.description   = %q{Securely proxying graphql requests from our app to shopify}
  spec.homepage      = "https://github.com/montalvomiguelo/shopify-graphql_proxy"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f =~ %r{^(test|spec|features)/}
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rack-test", "~> 1.0"
  spec.add_dependency "rack-proxy", "~> 0.6.4"
end
