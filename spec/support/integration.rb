# frozen_string_literal: true

RSpec.shared_context("with integration") do
  OmniAuth.config.test_mode = false

  def auth_headers(auth)
    {
      "Authorization" => auth,
      "Accept" => "application/json",
    }
  end

  def get_with_auth(path, auth)
    get(path, headers: auth_headers(auth))
  end

  def omniauth_log_in(invalid: false, data: {}, follow_redirect: true)
    invalid ? mock_invalid_auth_hash : mock_valid_auth_hash(data)
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:auth0]
    get(admin_user_auth0_omniauth_callback_path(code: "<fake_code>"))
    follow_redirect! if follow_redirect
  end

  def mock_valid_auth_hash(data = {})
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing. https://github.com/omniauth/omniauth/wiki/Integration-Testing
    OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new(valid_auth.deep_merge(data))
  end

  def mock_invalid_auth_hash
    OmniAuth.config.mock_auth[:auth0] = :invalid_credentials
  end

  def valid_auth
    {
      provider: "auth0",
      uid: "auth0|123456789",
      info: {
        name: "John Foo",
        email: "johnfoo@firstcircle.com",
        nickname: "john",
        image: "https://firstcircle.com/john.jpg",
      },
      credentials: {
        token: "ACCESS_TOKEN",
        expires_at: 1485373937,
        expires: true,
        refresh_token: "REFRESH_TOKEN",
        id_token: "JWT_ID_TOKEN",
        token_type: "bearer",
      },
      extra: {
        raw_info: {
          email: "johnfoo@firstcircle.com",
          email_verified: "true",
          name: "John Foo",
          picture: "https://firstcircle.com/john.jpg",
          user_id: "auth0|123456789",
          nickname: "john",
          created_at: "2014-07-15T17:19:50.387Z",
        },
      },
    }
  end
end
