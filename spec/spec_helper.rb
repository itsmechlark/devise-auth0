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

ENV["RAILS_ENV"] ||= "test"
ENV["AUTH0_CUSTOM_DOMAIN"] ||= "firstcircle-dev.eu.auth0.com"
ENV["AUTH0_DOMAIN"] ||= "firstcircle-dev.eu.auth0.com"
ENV["AUTH0_AUDIENCE"] ||= "https://rails-api-auth-sample.firstcircle.io"
ENV["AUTH0_CLIENT_ID"] ||= Faker::Internet.password
ENV["AUTH0_CLIENT_SECRET"] ||= Faker::Internet.password

require "pry-byebug"

require File.expand_path(
  "fixtures/rails_app/config/environment", __dir__
)

require "rspec/rails"
require "multi_json"
require "timecop"
require "vcr"
require "webmock/rspec"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

VCR.configure do |config|
  config.default_cassette_options = { match_requests_on: [:method, :uri] }
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.configure_rspec_metadata!
  config.hook_into(:webmock)

  unless ENV.key?("CI")
    config.default_cassette_options = { record: :new_episodes }
  end

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

  config.include(Devise::Test::ControllerHelpers, type: :controller)
  config.include(Devise::Test::ControllerHelpers, type: :view)
  config.include(Devise::Test::IntegrationHelpers, type: :request)
end
