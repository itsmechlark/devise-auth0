# frozen_string_literal: true

require "spec_helper"
require "devise/auth0/rails"

# rubocop:disable RSpec/FilePath
RSpec.describe(Devise::Auth0::Engine) do
  subject(:initializer) do
    described_class.initializers.detect do |initializer|
      initializer.name == "devise.auth0"
    end
  end

  describe "initializer position" do
    it { expect(initializer.before).to(eq("devise.omniauth")) }
  end

  describe "auth0 provider initialization" do
    context "when devise auth0 omniauth is true" do
      it "adds auth0 provider to omniauth from configuration" do
        middlewares = Rails.application.middleware
        auth0_provider = middlewares.find { |middleware| middleware.name == "OmniAuth::Strategies::Auth0" }
        expect(auth0_provider).not_to(be_nil)
      end
    end
  end
end
