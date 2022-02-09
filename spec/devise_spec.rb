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

  describe 'configuration' do
    subject(:config) { described_class::Auth0.config }

    it 'defaults to RS256 for algorithm' do
      expect(config.algorithm).to eq('RS256')
    end 

    it "defaults to ENV['AUTH0_AUDIENCE'] for aud" do
      expect(config.aud).to eq(ENV['AUTH0_AUDIENCE'])
    end 

    it "defaults to ENV['AUTH0_CLIENT_ID'] for client_id" do
      expect(config.client_id).to eq(ENV['AUTH0_CLIENT_ID'])
    end 

    it "defaults to ENV['AUTH0_CLIENT_SECRET'] for client_secret" do
      expect(config.client_secret).to eq(ENV['AUTH0_CLIENT_SECRET'])
    end 

    it "defaults to ENV['AUTH0_DOMAIN'] for domain" do
      expect(config.domain).to eq(ENV['AUTH0_DOMAIN'])
    end 

    it "defaults to false for omniauth" do
      expect(config.omniauth).to be_falsey
    end 
  end
end
