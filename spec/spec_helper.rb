# frozen_string_literal: true

require "simplecov"
SimpleCov.start("rails") do
  add_filter "/spec/"
  minimum_coverage 95
  minimum_coverage_by_file 90
end

require "bundler/setup"
require "em-http" # As of webmock 1.4.0, em-http must be loaded first
require "multi_json"
require "webmock/rspec"

ENV["RAILS_ENV"] ||= "test"
require File.expand_path(
  "fixtures/rails_app/config/environment", __dir__
)

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.run_all_when_everything_filtered = true
  config.filter_run(:focus)

  config.expect_with(:rspec) do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with(:rspec) do |mocks|
    mocks.syntax = :expect
  end

  config.order = :random

  config.before do
    WebMock.reset!
    WebMock.disable_net_connect!
  end
end
