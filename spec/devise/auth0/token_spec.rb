# frozen_string_literal: true

require "spec_helper"
require "devise/auth0/token"

RSpec.describe(Devise::Auth0::Token) do
  include_context("with fixtures")

  before { Timecop.freeze(Time.zone.at(1644312671)) }

  after { Timecop.return }

  let(:token) { described_class.new(jwt_token) }

  describe ".parse" do
    subject(:parsed_token) do
      VCR.use_cassette("auth0/jwks") do
        described_class.parse(jwt_token)
      end
    end

    it { is_expected.to(be_a(described_class)) }
  end

  describe "#auth0_id" do
    it "returns sub if has payload" do
      allow(token).to(receive(:verify).and_return([{ "sub" => "auth0|12345" }]))

      expect(token.auth0_id).to(eq("auth0|12345"))
    end

    it "returns false if no payload" do
      allow(token).to(receive(:verify).and_return(nil))

      expect(token.auth0_id).to(be_nil)
    end
  end

  describe "#user" do
    let(:user) { token.user }

    it "returns user data" do
      VCR.use_cassette("auth0/user/google-oauth2|101843459961769220909") do
        expect(user).to(be_present)
      end
    end

    context "when client credentials" do
      before do
        allow(token)
          .to(receive(:verify)
          .and_return([{ "azp" => "12345", "gty" => "client-credentials" }]))
      end

      it { expect(user["user_id"]).to(eq("12345")) }
      it { expect(user["email"]).to(eq("12345@#{::Devise.auth0.domain}")) }
    end
  end

  describe "#bot?" do
    before do
      allow(token)
        .to(receive(:verify)
        .and_return([{}]))
    end

    it { expect(token).not_to(be_bot) }

    context "when not verified" do
      before do
        allow(token)
          .to(receive(:verify)
          .and_return(nil))
      end

      it { expect(token).not_to(be_bot) }
    end

    context "when client credentials" do
      before do
        allow(token)
          .to(receive(:verify)
          .and_return([{ "gty" => "client-credentials" }]))
      end

      it { expect(token).to(be_bot) }
    end
  end

  describe "#scopes" do
    before do
      allow(token)
        .to(receive(:verify)
        .and_return([{ "scope" => "read:users read:user/roles" }]))
    end

    it { expect(token.scopes).to(match_array(["read:users", "read:user/roles"])) }

    context "when not verified" do
      before do
        allow(token)
          .to(receive(:verify)
          .and_return(nil))
      end

      it { expect(token.scopes).to(be_empty) }
    end
  end

  describe "#verify" do
    it "returns payload" do
      VCR.use_cassette("auth0/jwks") do
        expect(token.verify).to(be_present)
      end
    end

    it "returns nil if decode error" do
      allow(JWT).to(receive(:decode).and_raise(JWT::DecodeError))

      expect(token.verify).to(be_nil)
    end
  end

  describe "#valid?" do
    it "returns true if has payload" do
      allow(token).to(receive(:verify).and_return([{ "sub" => "auth0|12345" }]))

      expect(token).to(be_valid)
    end

    it "returns false if no payload" do
      allow(token).to(receive(:verify).and_return(nil))

      expect(token).not_to(be_valid)
    end
  end
end
