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
end
