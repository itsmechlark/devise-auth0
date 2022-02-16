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

  describe "#user_id" do
    it "returns sub if has payload" do
      allow(token).to(receive(:verify).and_return([{ "sub" => "auth0|12345" }]))

      expect(token.user_id).to(eq("auth0|12345"))
    end

    it "returns false if no payload" do
      allow(token).to(receive(:verify).and_return(nil))

      expect(token.user_id).to(be_nil)
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
          .and_return([{ "sub" => "12345@clients", "gty" => "client-credentials" }]))
      end

      it { expect(user["user_id"]).to(eq("12345@clients")) }
      it { expect(user["email"]).to(eq("12345@clients.#{::Devise::Auth0.config.domain}")) }
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
