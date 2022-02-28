# frozen_string_literal: true

require "spec_helper"
require "devise/auth0"

RSpec.describe(Devise) do
  include_context("with fixtures")

  let!(:old_domain) { described_class.auth0.domain }

  after {  described_class.auth0.domain = old_domain }

  describe ".auth0" do
    let(:domain) { Faker::Internet.domain_name }

    it "yields to Devise.auth0" do
      described_class.auth0 { |auth0| auth0.domain = domain }

      expect(described_class.auth0.domain).to(eq(domain))
    end
  end

  describe "configuration" do
    subject(:config) { described_class::Auth0.config }

    it "defaults to RS256 for algorithm" do
      expect(config.algorithm).to(eq("RS256"))
    end

    it "defaults to ENV['AUTH0_AUDIENCE'] for aud" do
      expect(config.aud).to(match_array(ENV["AUTH0_AUDIENCE"].to_s.split(",")))
    end

    it "defaults to ENV['AUTH0_CLIENT_ID'] for client_id" do
      expect(config.client_id).to(eq(ENV["AUTH0_CLIENT_ID"]))
    end

    it "defaults to ENV['AUTH0_CLIENT_SECRET'] for client_secret" do
      expect(config.client_secret).to(eq(ENV["AUTH0_CLIENT_SECRET"]))
    end

    it "defaults to ENV['AUTH0_DOMAIN'] for domain" do
      expect(config.domain).to(eq(ENV["AUTH0_DOMAIN"]))
    end

    it "defaults to false for omniauth" do
      # TODO: Setting this manually here since in the fixture rails app's
      # devise initializer we're setting the omniauth option to true
      config.omniauth = false
      expect(config.omniauth).to(be_falsey)
    end

    it "defaults to openid for scope" do
      expect(config.scope).to(eq("openid"))
    end
  end

  describe ".logout" do
    let(:user) do
      auth0_user_model.create(
        provider: "google-oauth2",
        uid: "114473891729720308813",
        email: Faker::Internet.unique.email,
        password: "password"
      )
    end

    it "deletes all grants for the user" do
      VCR.use_cassette("auth0/user/google-oauth2|101843459961769220909/logout") do
        described_class::Auth0.logout(user)
      end
    end
  end
end
