require 'simplecov'

SimpleCov.start

require 'straight-server-kit'
require 'webmock/rspec'
require 'vcr'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter
]

Dir['./spec/support/**/*.rb'].each do |file|
  require file
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr'
  config.hook_into :webmock
end

# RSpec.configure do |config|
# end
