# frozen_string_literal: true

require "devise/strategies/base"

require_relative "helpers"
require_relative "token"

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
        resource = token.valid? && mapping.to.from_auth0_token(token)
        return success!(resource) if resource

        fail!(:invalid)
      end

      private

      def token
        @token ||= ::Devise::Auth0::Token.parse(auth)
      end

      def auth
        @auth ||= ::Devise::Auth0::Helpers.get_auth(env)
      end
    end
  end
end

Warden::Strategies.add(:auth0, Devise::Strategies::Auth0)
