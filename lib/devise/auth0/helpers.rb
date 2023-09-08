# frozen_string_literal: true

module Devise
  module Auth0
    # Helpers to parse token from a request and to a response
    module Helpers
      AUTH_METHOD = "Bearer"

      class << self
        # Parses the token from a rack request
        #
        # @param env [Hash] rack env hash
        # @return [String] JWT token
        # @return [nil] if token is not present
        def get_auth(env)
          auth = env["HTTP_AUTHORIZATION"].presence
          return unless auth

          method, token = auth.split
          method == AUTH_METHOD ? token : nil
        end
      end
    end
  end
end
