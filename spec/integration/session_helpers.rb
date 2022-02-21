# frozen_string_literal: true

module Requests
  module SessionHelpers
    def log_in(invalid: false)
      invalid ? mock_invalid_auth_hash : mock_valid_auth_hash
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:auth0]
      get("/auth/auth0/callback?code=<fake_code>")
    end

    def mock_valid_auth_hash
      # The mock_auth configuration allows you to set per-provider (or default)
      # authentication hashes to return during integration testing. https://github.com/omniauth/omniauth/wiki/Integration-Testing
      OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new(valid_auth)
    end

    def mock_invalid_auth_hash
      OmniAuth.config.mock_auth[:auth0] = :invalid_credentials

      OmniAuth.config.on_failure = proc { |env|
        OmniAuth::FailureEndpoint.new(env).redirect_to_failure
      }
    end

    def valid_auth
      {
        provider: "google_oauth2",
        uid: "123456789",
        info: {
          name: "John Doe",
          email: "john.doe@example.com",
          first_name: "John",
          last_name: "Doe",
          image: "https://lh3.googleusercontent.com/url/photo.jpg",
        },
        credentials: {
          token: "token",
          refresh_token: "another_token",
          expires_at: 1354920555,
          expires: true,
        },
        extra: {
          raw_info: {
            sub: "123456789",
            email: "john.doe@example.com",
            email_verified: true,
            name: "John Doe",
            given_name: "John",
            family_name: "Doe",
            profile: "https://plus.google.com/123456789",
            picture: "https://lh3.googleusercontent.com/url/photo.jpg",
            gender: "male",
            birthday: "0000-06-25",
            locale: "en",
            hd: "example.com",
          },
        },
      }
    end
  end
end
