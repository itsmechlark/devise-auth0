# frozen_string_literal: true

require "faraday"
require "faraday/http_cache"
require "faraday/retry"
require "jwt"

module Devise
  module Auth0
    # Helpers to parse token from a request and to a response
    class Token
      class << self
        def parse(auth, resource_class)
          token = new(auth, resource_class)
          token.verify
          token
        end
      end

      def initialize(auth, resource_class)
        @auth = auth.presence
        @resource_class = resource_class
      end

      def provider
        auth0_id&.split("|")&.first
      end

      def uid
        auth0_id&.split("|")&.last
      end

      def auth0_id
        return if verify.nil?
        return "auth0|#{verify[0]["azp"]}" if bot?

        verify[0]["sub"]
      end

      def user
        @user ||= if bot?
          {
            "user_id" => uid,
            "email" => "#{uid}@#{config.domain}",
          }
        else
          ::Devise.auth0.cache.fetch("devise-auth0/#{auth0_id}", expires_in: ::Devise.auth0.cache_expires_in) do
            client.user(auth0_id)
          end
        end
      end

      def bot?
        return false if verify.nil?

        verify[0]["gty"] == "client-credentials"
      end

      def scopes
        return [] if verify.nil?

        verify[0]["scope"].to_s.split(" ")
      end

      def permissions
        return [] if verify.nil?

        verify[0]["permissions"].presence || []
      end

      def verify
        @payload ||= JWT.decode(
          @auth,
          nil,
          true, # Verify the signature of this token
          algorithms: config.algorithm,
          iss: issuer,
          verify_iss: true,
          aud: config.aud,
          verify_aud: true,
        ) do |header|
          jwks_hash[header["kid"]]
        end
      rescue JWT::DecodeError
        nil
      end

      def valid?
        !verify.nil?
      end

      private

      def config
        @resource_class.auth0_config
      end

      def client
        @resource_class.auth0_client
      end

      def issuer
        "https://#{config.custom_domain.presence || config.domain.presence}/"
      end

      def jwks_hash
        conn = ::Faraday.new("https://#{config.custom_domain}") do |f|
          f.use(:http_cache, store: ::Devise.auth0.cache)
          f.request(:retry, max: 3)
          f.adapter(::Faraday.default_adapter)
        end
        jwks_keys = JSON.parse(conn.get("/.well-known/jwks.json").body)["keys"]
        Hash[
          jwks_keys
            .map do |k|
            [
              k["kid"],
              OpenSSL::X509::Certificate.new(
                Base64.decode64(k["x5c"].first),
              ).public_key,
            ]
          end
        ]
      end
    end
  end
end
