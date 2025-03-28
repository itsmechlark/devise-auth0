# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Devise::Strategies::Auth0, type: :request) do
  include_context("with integration")
  include_context("with fixtures")

  after { Timecop.return }

  context "with a valid token" do
    before do
      Timecop.freeze(Time.zone.at(1646975954))
      VCR.use_cassette("auth0/user/google-oauth2|101843459961769220909") do
        get_with_auth("/ping", "Bearer #{jwt_token}")
      end
    end

    it { expect(auth0_admin_user_model.where(provider: "google-oauth2", uid: "101843459961769220909")).to(be_exists) }
    it { expect(response).to(have_http_status(:ok)) }
    it { expect(response.body).to(include("google-oauth2|101843459961769220909")) }
  end

  context "with a token expires" do
    before { Timecop.freeze(10.years.from_now) }

    it "unauthorize requests" do
      VCR.use_cassette("auth0/jwks") do
        get_with_auth("/ping", "Bearer #{jwt_token}")
      end

      expect(response).to(have_http_status(:unauthorized))
    end
  end

  context "with a invalid token" do
    it "unauthorize requests" do
      VCR.use_cassette("auth0/jwks") do
        get_with_auth("/ping", "Bearer 12345")
      end

      expect(response).to(have_http_status(:unauthorized))
    end
  end
end
