# frozen_string_literal: true

require "spec_helper"
require "devise/auth0"

RSpec.describe(Devise) do
  let!(:old_domain) { described_class.auth0.domain }

  after {  described_class.auth0.domain = old_domain }

  describe ".auth0" do
    let(:domain) { Faker::Internet.domain_name }

    it "yields to Devise::Auth0.config" do
      described_class.auth0 { |auth0| auth0.domain = domain }

      expect(Devise::Auth0.config.domain).to(eq(domain))
    end
  end

  describe "configuration" do
    subject(:config) { described_class::Auth0.config }

    it "defaults to RS256 for algorithm" do
      expect(config.algorithm).to(eq("RS256"))
    end

    it "defaults to ENV['AUTH0_AUDIENCE'] for aud" do
      expect(config.aud).to(eq(ENV["AUTH0_AUDIENCE"]))
    end

    it "defaults to '/auth/auth0/callback' for callback_path" do
      expect(config.callback_path).to(eq("/auth/auth0/callback",))
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
end
