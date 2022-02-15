# frozen_string_literal: true

require "devise"
require "dry-configurable"

# Authentication library
module Devise
  module Models
    autoload :Auth0, "devise/models/auth0"
  end

  module Strategies
    autoload :Auth0, "devise/strategies/auth0"
  end

  # Yields to Devise::Auth0.config
  def self.auth0
    return Devise::Auth0.config unless block_given?

    yield(Devise::Auth0.config)
  end

  add_module(:auth0, strategy: true, model: "devise/models/auth0")

  # Auth0 extension for devise
  module Auth0
    extend ::Dry::Configurable

    setting(:algorithm, default: "RS256")
    setting(:aud, default: ENV["AUTH0_AUDIENCE"].presence)
    setting(:callback_path, default: "/auth/auth0/callback")
    setting(:client_id, default: ENV["AUTH0_CLIENT_ID"].presence)
    setting(:client_secret, default: ENV["AUTH0_CLIENT_SECRET"].presence)
    setting(:domain, default: ENV["AUTH0_DOMAIN"].presence)
    setting(:omniauth, default: false)
    setting(:scope, default: "openid")
  end
end

require "devise/auth0/version"
require "devise/auth0/rails_engine"
