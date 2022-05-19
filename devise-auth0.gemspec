# frozen_string_literal: true

require_relative "lib/devise/auth0/version"

Gem::Specification.new do |s|
  s.name = "devise-auth0"
  s.version = Devise::Auth0.gem_version
  s.authors = ["First Circle Engineering"]
  s.email = ["tech@firstcircle.com"]

  s.summary = "Auth0 authentication for devise"
  s.description = "Auth0 authentication for devise"
  s.homepage = "https://github.com/carabao-capital/devise-auth0"
  s.license = "MIT"

  s.metadata = {
    "homepage_uri" => s.homepage,
    "changelog_uri" => "https://github.com/carabao-capital/devise-auth0/releases/tag/v#{s.version}",
    "source_code_uri" => "https://github.com/carabao-capital/devise-auth0/tree/v#{s.version}",
    "bug_tracker_uri" => "https://github.com/carabao-capital/devise-auth0/issues",
  }

  s.files = Dir["{app,lib}/**/*", "CHANGELOG.md", "LICENSE.md"]
  s.test_files = %x(git ls-files -- spec/*).split("\n")
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["LICENSE.md"]

  s.add_runtime_dependency("auth0", "~> 5.6")
  s.add_runtime_dependency("devise", "~> 4.8")
  s.add_runtime_dependency("dry-configurable", "~> 0.13")
  s.add_runtime_dependency("faraday", "~> 1.10.0")
  s.add_runtime_dependency("jwt", "~> 2.3")
  s.add_runtime_dependency("mail")
  s.add_runtime_dependency("net-smtp")
  s.add_runtime_dependency("omniauth-auth0", "~> 3.0")
  s.add_runtime_dependency("omniauth-rails_csrf_protection")

  s.add_development_dependency("appraisal", "~> 2.4")
  s.add_development_dependency("bundler", "~> 2.0")
  s.add_development_dependency("dotenv")
  s.add_development_dependency("faker", "~> 2.0")
  s.add_development_dependency("multipart-parser", "~> 0.1.1")
  s.add_development_dependency("pry-byebug", "~> 3.7")
  s.add_development_dependency("rack_session_access")
  s.add_development_dependency("rake", "~> 13.0")
  s.add_development_dependency("rspec-rails", "~> 4.0")
  s.add_development_dependency("rubocop-performance")
  s.add_development_dependency("rubocop-rails")
  s.add_development_dependency("rubocop-rake")
  s.add_development_dependency("rubocop-rspec")
  s.add_development_dependency("rubocop-shopify", "~> 2.6.0")
  s.add_development_dependency("simplecov", ">= 0.21.2")
  s.add_development_dependency("timecop")
  s.add_development_dependency("vcr", "~> 6.0")
  s.add_development_dependency("webmock", "~> 3.4")
end
