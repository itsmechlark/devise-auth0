# frozen_string_literal: true

require "spec_helper"
require "devise/auth0/rails"

RSpec.describe("Devise::Engine") do
  subject(:initializer) do
    described_class.initializers.detect do |initializer|
      initializer.name == "devise.omniauth"
    end
  end

  let(:described_class) { Devise::Engine }

  describe "initializer position" do
    context "when before initializer" do
      it { expect(initializer.before).to(eq(:build_middleware_stack)) }
    end

    context "when after initializer" do
      it { expect(initializer.after).to(eq(:load_config_initializers)) }
    end
  end

  describe "auth0 provider initialization" do
    context "when devise auth0 omniauth is true" do
      it "adds auth0 provider to omniauth from configuration" do
        middlewares = Rails.application.middleware
        auth0_provider = middlewares.find { |middleware| middleware.name == "OmniAuth::Builder" }
        expect(auth0_provider).not_to(be_nil)
      end
    end
  end
end
