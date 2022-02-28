# frozen_string_literal: true

require "spec_helper"

RSpec.describe("Login with Auth0", type: :request) do
  include_context("with integration")

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.mock_auth.delete(:auth0)
    Rails.application.env_config.delete("omniauth.auth")
    OmniAuth.config.test_mode = false
  end

  describe "GET /<scope>/auth/auth0/callback" do
    context "with valid credentials" do
      before { omniauth_log_in(invalid: false) }

      it { expect(response).to(have_http_status(:ok)) }
      it { expect(response.body).to(include("auth0|123456789")) }
      it { expect(session["devise.auth0_data"]).to(be_nil) }
    end

    context "with valid credentials and need signup" do
      before { omniauth_log_in(invalid: false, data: { info: { email: nil } }, follow_redirect: false) }

      it { expect(response).to(redirect_to(new_admin_user_session_url)) }
      it { expect(session["devise.auth0_data"]).not_to(be_nil) }
    end

    context "with invalid credentials" do
      before { omniauth_log_in(invalid: true) }

      it { expect(response.body).not_to(include("auth0|123456789")) }
      it { expect(session["devise.auth0_data"]).to(be_nil) }
    end

    context "with error parameters" do
      before do
        OmniAuth.config.mock_auth[:auth0] = :access_denied
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:auth0]
        get(admin_user_auth0_omniauth_callback_path(error: :access_denied))
      end

      it { expect(session["devise.auth0_data"]).to(be_nil) }
      it { expect(response).to(redirect_to(new_admin_user_session_url)) }
    end
  end

  describe "POST /<scope>/auth/auth0" do
    context "with exceptions from OmniAuth" do
      before do
        OmniAuth.config.mock_auth[:auth0] = :invalid_credentials
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:auth0]
        post admin_user_auth0_omniauth_authorize_url
        follow_redirect!
      end

      it { expect(session["devise.auth0_data"]).to(be_nil) }
      it { expect(response).to(redirect_to(new_admin_user_session_url)) }
    end
  end
end
