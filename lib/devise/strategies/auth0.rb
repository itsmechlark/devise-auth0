# frozen_string_literal: true

require "devise/strategies/base"

require_relative "../auth0/helpers"
require_relative "../auth0/token"

module Devise
  module Strategies
    # Warden strategy to authenticate an user through a JWT token in the
    # `Authorization` request header
    class Auth0 < Devise::Strategies::Base
      def valid?
        !auth.nil?
      end

      def store?
        false
      end

      def authenticate!
        if token.valid?
          resource = mapping.to.from_auth0_token(token)
          return success!(resource) if resource.persisted?
        end

        fail!(:invalid)
      end

      private

      def token
        @token ||= mapping.to.parse_auth0_token(auth)
      end

      def auth
        @auth ||= ::Devise::Auth0::Helpers.get_auth(env)
      end
    end
  end
end

Warden::Strategies.add(:auth0, Devise::Strategies::Auth0)
