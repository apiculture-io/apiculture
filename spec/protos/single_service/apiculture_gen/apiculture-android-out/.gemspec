# -*- encoding: utf-8 -*-

require File.expand_path('../lib/apiculture/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "apiculture"
  gem.version       = Apiculture::VERSION
  gem.summary       = %q{Build client libraries for your web service. Transform your API into an SDK.}
  gem.description   = %q{Build client libraries for your web service. Transform your API into an SDK.}
  gem.license       = "MIT"
  gem.authors       = ["Hsiu-Fan Wang"]
  gem.email         = "hfwang@porkbuns.net"
  gem.homepage      = "https://rubygems.org/gems/apiculture"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'protobuf', '~> 3.0.0'
  gem.add_dependency 'protobuf_descriptor', '~> 1.0.0'
  gem.add_dependency 'thor', '~> 0.19.1'

  gem.add_development_dependency 'pry', '~> 0.9.12.6'
  gem.add_development_dependency 'rake', '~> 10.3'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
end
