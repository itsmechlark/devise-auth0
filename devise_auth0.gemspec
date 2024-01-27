# frozen_string_literal: true

require_relative "lib/devise/auth0/version"

Gem::Specification.new do |s|
  s.name = "devise_auth0"
  s.version = Devise::Auth0.gem_version
  s.authors = ["John Chlark Sumatra"]
  s.email = ["clark@sumatra.com.ph"]

  s.summary = "Auth0 authentication for devise"
  s.description = "Auth0 authentication for devise"
  s.homepage = "https://github.com/itsmechlark/devise_auth0"
  s.license = "MIT"

  s.metadata = {
    "homepage_uri" => s.homepage,
    "changelog_uri" => "https://github.com/itsmechlark/devise_auth0/releases/tag/v#{s.version}",
    "source_code_uri" => "https://github.com/itsmechlark/devise_auth0/tree/v#{s.version}",
    "bug_tracker_uri" => "https://github.com/itsmechlark/devise_auth0/issues",
    "github_repo" => "https://github.com/itsmechlark/devise_auth0",
  }

  s.files = Dir["{app,lib}/**/*", "CHANGELOG.md", "LICENSE.md"]
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 2.7.0"
  s.extra_rdoc_files = ["LICENSE.md"]

  s.add_runtime_dependency("auth0", "~> 5.6")
  s.add_runtime_dependency("devise", "~> 4.8")
  s.add_runtime_dependency("dry-configurable", ">= 0.13", "< 2.0")
  s.add_runtime_dependency("faraday", ">= 1.10", "< 2.10")
  s.add_runtime_dependency("faraday-http-cache")
  s.add_runtime_dependency("faraday-retry")
  s.add_runtime_dependency("jwt", "~> 2.3")
  s.add_runtime_dependency("mail")
  s.add_runtime_dependency("net-smtp")
  s.add_runtime_dependency("omniauth-auth0", "~> 3.0")
  s.add_runtime_dependency("omniauth-rails_csrf_protection")

  s.add_development_dependency("appraisal", "~> 2.4")
  s.add_development_dependency("bundler", "~> 2.0")
  s.add_development_dependency("code-scanning-rubocop")
  s.add_development_dependency("dotenv")
  s.add_development_dependency("faker", "~> 3.2")
  s.add_development_dependency("multi_json")
  s.add_development_dependency("multipart-parser", "~> 0.1.1")
  s.add_development_dependency("pry-byebug", "~> 3.7")
  s.add_development_dependency("rack_session_access")
  s.add_development_dependency("rake", "~> 13.0")
  s.add_development_dependency("rspec-rails")
  s.add_development_dependency("rubocop-performance")
  s.add_development_dependency("rubocop-rails")
  s.add_development_dependency("rubocop-rake")
  s.add_development_dependency("rubocop-rspec")
  s.add_development_dependency("rubocop-shopify", "~> 2.14")
  s.add_development_dependency("simplecov", ">= 0.21.2")
  s.add_development_dependency("simplecov-lcov")
  s.add_development_dependency("timecop")
  s.add_development_dependency("vcr", "~> 6.0")
  s.add_development_dependency("webmock", "~> 3.4")
end
