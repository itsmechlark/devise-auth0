# frozen_string_literal: true

module ActionDispatch
  module Routing
    class Mapper
      protected

      def devise_auth0_callback(mapping, controllers) # :nodoc:
        return unless mapping.to.auth0_config.omniauth

        path_prefix = Devise.omniauth_path_prefix || "/#{mapping.fullpath}/auth".squeeze("/")
        set_omniauth_path_prefix!(path_prefix)

        match(
          "/auth/auth0",
          to: "#{controllers[:auth0_callbacks]}#passthru",
          as: :auth0_omniauth_authorize,
          via: [:get, :post],
        )

        match(
          "/auth/auth0/failure",
          to: "#{controllers[:auth0_callbacks]}#failure",
          as: :auth0_omniauth_failure,
          via: [:get, :post],
        )

        match(
          "/auth/auth0/callback",
          to: "#{controllers[:auth0_callbacks]}#callback",
          as: :auth0_omniauth_callback,
          via: [:get, :post],
        )
      end
    end
  end
end
