# frozen_string_literal: true

require "devise"
require "dry-configurable"

# Authentication library
module Devise
  module Models
    autoload :Auth0, "devise/auth0/model"
  end

  module Strategies
    autoload :Auth0, "devise/auth0/strategy"
  end

  # Yields to Devise::Auth0.config
  def self.auth0
    return Devise::Auth0.config unless block_given?

    yield(Devise::Auth0.config)
  end

  add_module(:auth0, strategy: :auth0)

  # Auth0 extension for devise
  module Auth0
    extend ::Dry::Configurable

    setting(:algorithm, default: "RS256")
    setting(:aud, default: ENV["AUTH0_AUDIENCE"].presence)
    setting(:client_id, default: ENV["AUTH0_CLIENT_ID"].presence)
    setting(:client_secret, default: ENV["AUTH0_CLIENT_SECRET"].presence)
    setting(:domain, default: ENV["AUTH0_DOMAIN"].presence)
    setting(:omniauth, default: false)
  end
end

require "devise/auth0/version"
