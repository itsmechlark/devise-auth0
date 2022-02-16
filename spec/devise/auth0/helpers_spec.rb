# frozen_string_literal: true

require "spec_helper"
require "devise/auth0/helpers"

RSpec.describe(Devise::Auth0::Helpers) do
  describe ".get_auth(env)" do
    it "returns auth" do
      env = { "HTTP_AUTHORIZATION" => "Bearer some-jwt-token" }

      expect(described_class.get_auth(env)).to(eq("some-jwt-token"))
    end
  end
end
