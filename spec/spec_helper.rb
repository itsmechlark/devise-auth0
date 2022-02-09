# frozen_string_literal: true

require "simplecov"
SimpleCov.start("rails") do
  add_filter "/lib/devise/auth0/version.rb"
  add_filter "/spec/"
  minimum_coverage 95
  minimum_coverage_by_file 90
end

require "bundler/setup"
require "dotenv/load"
require "faker"
require "multi_json"
require "timecop"
require "vcr"
require "webmock/rspec"

ENV["RAILS_ENV"] ||= "test"
ENV["AUTH0_DOMAIN"] ||= "firstcircle-dev.eu.auth0.com"
ENV["AUTH0_AUDIENCE"] ||= "https://rails-api-auth-sample.firstcircle.io"
ENV["AUTH0_CLIENT_ID"] ||= Faker::Internet.password
ENV["AUTH0_CLIENT_SECRET"] ||= Faker::Internet.password

require File.expand_path(
  "fixtures/rails_app/config/environment", __dir__
)

require "rspec/rails"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into(:webmock)

  [
    "AUTH0_DOMAIN",
    "AUTH0_AUDIENCE",
    "AUTH0_CLIENT_ID",
    "AUTH0_CLIENT_SECRET",
  ].each do |var|
    config.filter_sensitive_data("[#{var}]") { ENV[var] }
  end
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.use_transactional_fixtures = true
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
