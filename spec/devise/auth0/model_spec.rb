# frozen_string_literal: true

require "spec_helper"

# rubocop:disable RSpec/FilePath
RSpec.describe(Devise::Models::Auth0) do
  include_context("with fixtures")

  let(:model) { auth0_user_model }
  let(:user) { auth0_user }

  describe ".required_fields" do
    it { expect(described_class.required_fields(model)).to(eq([])) }
  end

  describe(".from_auth0_token(token)") do
    let(:token) { instance_double("Token", user_id: user.uid) }

    it "finds record which has given `user_id` as `uid`" do
      expect(model.from_auth0_token(token)).to(eq(user))
    end

    context "when uid does not match" do
      let(:user) { model.from_auth0_token(token) }
      let(:token) do
        instance_double(
          "Token",
          user_id: Faker::Internet.unique.uuid,
          user: { "email" => Faker::Internet.unique.email }
        )
      end

      it { expect(user.uid).to(eq(token.user_id)) }
      it { expect(user.email).to(eq(token.user["email"])) }
    end
  end
end
