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

  describe "#can?" do
    subject(:user) { auth0_user }

    let(:role_class) { instance_double("User::Role").class }

    before { user.auth0_scopes = ["read:users", "update", "read:user/roles"] }

    it { is_expected.to(be_can(:read, User)) }
    it { is_expected.to(be_can(:read, "user/roles")) }
    it { is_expected.not_to(be_can(:create, User)) }

    context "without resource_class" do
      it { is_expected.to(be_can(:update)) }
      it { is_expected.not_to(be_can(:create)) }
    end
  end

  describe "#cannot?" do
    subject(:user) { auth0_user }

    before do
      allow(auth0_user).to(receive(:can?).with(:read, User).and_return(true))
      allow(auth0_user).to(receive(:can?).with(:update, User).and_return(false))
      allow(auth0_user).to(receive(:can?).with(:delete).and_return(false))
    end

    it { is_expected.not_to(be_cannot(:read, User)) }
    it { is_expected.to(be_cannot(:update, User)) }
    it { is_expected.to(be_cannot(:delete)) }
  end

  describe "#auth0_scopes" do
    context "when user" do
      subject(:scopes) do
        VCR.use_cassette("auth0/user/google-oauth2|101843459961769220909/permissions") do
          user.send(:auth0_scopes)
        end
      end

      let(:user) do
        auth0_user_model.create(
          uid: "google-oauth2|101843459961769220909",
          email: Faker::Internet.unique.email,
          password: "password",
          bot: false
        )
      end

      it { is_expected.to(match_array(["create:leads", "delete:leads"])) }
    end

    context "when bot" do
      subject(:scopes) do
        VCR.use_cassette("auth0/grants/UDuyRC6XeVr9eCPIrOP0dgIL0xTLs33f") do
          bot.send(:auth0_scopes)
        end
      end

      let(:bot) do
        auth0_user_model.create(
          uid: "UDuyRC6XeVr9eCPIrOP0dgIL0xTLs33f",
          email: Faker::Internet.unique.email,
          password: "password",
          bot: true
        )
      end

      it { is_expected.to(match_array(["read:leads"])) }
    end
  end

  describe(".from_auth0_token(token)") do
    let(:user) { model.from_auth0_token(token) }
    let(:token) { instance_double("Token", user_id: auth0_user.uid, scopes: []) }

    it "finds record which has given `user_id` as `uid`" do
      expect(model.from_auth0_token(token)).to(eq(auth0_user))
    end

    context "when uid does not match" do
      let(:token) do
        instance_double(
          "Token",
          user_id: Faker::Internet.unique.uuid,
          user: { "email" => Faker::Internet.unique.email },
          scopes: [],
          bot?: false
        )
      end

      it { expect(user).to(be_persisted) }
      it { expect(user.uid).to(eq(token.user_id)) }
      it { expect(user.email).to(eq(token.user["email"])) }
    end

    context "when bot" do
      let(:token) do
        uid = Faker::Internet.unique.uuid

        instance_double(
          "Token",
          user_id: uid,
          user: { "email" => "#{uid}.#{Devise::Auth0.config.domain}" },
          scopes: [],
          bot?: true
        )
      end

      before { allow(token).to(receive(:bot?).and_return(true)) }

      it { expect(user).to(be_persisted) }
      it { expect(user).to(be_bot) }
    end
  end
end
