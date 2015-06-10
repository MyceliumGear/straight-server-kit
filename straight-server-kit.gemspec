lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'straight-server-kit/version'

Gem::Specification.new do |spec|
  spec.name        = 'straight-server-kit'
  spec.version     = StraightServerKit::VERSION
  spec.authors     = ['Alexander Pavlenko']
  spec.email       = ['alerticus@gmail.com']
  spec.summary     = %q{Straight Server Kit is the official Ruby library for Straight Server's API}
  spec.description = %q{Straight Server Kit is the official Ruby library for Straight Server's API}
  spec.homepage    = 'https://github.com/MyceliumGear/straight-server-kit'
  spec.license     = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'virtus', '~> 1.0.5'
  spec.add_dependency 'resource_kit', '~> 0.1.3'
  spec.add_dependency 'kartograph', '~> 0.2.2'
  spec.add_dependency 'faraday', '~> 0.9.1'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'activesupport'
end
