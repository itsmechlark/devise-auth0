# frozen_string_literal: true

require "devise"
require "dry-configurable"

require "devise/auth0/client"

# Authentication library
module Devise
  # Yields to Devise::Auth0.config
  class << self
    def auth0
      return Devise::Auth0.config unless block_given?

      yield(Devise::Auth0.config)
    end
  end

  module Models
    autoload :Auth0, "devise/models/auth0"
  end

  module Strategies
    autoload :Auth0, "devise/strategies/auth0"
  end

  # Auth0 extension for devise
  module Auth0
    extend ::Dry::Configurable

    setting(:algorithm, default: "RS256")
    setting(
      :aud,
      default: ENV["AUTH0_AUDIENCE"].presence,
      constructor: ->(aud) { aud.is_a?(Array) ? aud : aud.to_s.split(",") },
    )
    setting(:client_id, default: ENV["AUTH0_CLIENT_ID"].presence)
    setting(:client_secret, default: ENV["AUTH0_CLIENT_SECRET"].presence)
    setting(:custom_domain, default: ENV["AUTH0_CUSTOM_DOMAIN"].presence)
    setting(:domain, default: ENV["AUTH0_DOMAIN"].presence)
    setting(:omniauth, default: false)
    setting(:scope, default: "openid")
    setting(:email_domains_allowlist, default: [])
    setting(:email_domains_blocklist, default: [])
    setting(:cache)
    setting(:cache_expires_in, default: 15.minutes)

    class << self
      def logout(record)
        record.class.auth0_client.grants(user_id: record.auth0_id).each do |grant|
          record.class.auth0_client.delete_grant(grant["id"], record.auth0_id)
        end
      end
    end
  end

  add_module(:auth0, strategy: true, controller: :auth0_callbacks, route: { auth0_callback: [:callback] })
end

require "devise/auth0/version"
require "devise/auth0/rails"
require "devise/strategies/auth0"
