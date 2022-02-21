# frozen_string_literal: true

require "spec_helper"
require_relative "session_helpers"

include Requests::SessionHelpers

describe "Login with Auth0", type: :request do
  before do
    OmniAuth.config.test_mode = true
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:auth0]
  end

  after do
    OmniAuth.config.mock_auth[:auth0] = nil
  end

  context "with valid credentials" do
    describe "login user" do
      before do
        log_in(invalid: false)
      end

      it "successful" do
        expect(response).to(have_http_status(:ok))
      end

      it "populates session[:userinfo]" do
        expect(session[:userinfo]).not_to(be(nil))
      end
    end
  end

  context "with invalid credentials" do
    describe "log in user" do
      before do
        log_in(invalid: true)
      end

      it "not successful" do
        expect(response).not_to(have_http_status(:ok))
      end

      it "does not populates session[:userinfo]" do
        expect(session[:userinfo]).to(be(nil))
      end
    end
  end
end
