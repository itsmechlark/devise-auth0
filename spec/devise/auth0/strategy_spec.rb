# frozen_string_literal: true

require "spec_helper"

# rubocop:disable RSpec/FilePath
RSpec.describe(Devise::Strategies::Auth0) do
  it "adds to Warden with auth0 name" do
    expect(Warden::Strategies._strategies).to(include(
      auth0: described_class
    ))
  end

  describe "#valid?" do
    context "when Authorization header is valid" do
      it "returns true" do
        env = { "HTTP_AUTHORIZATION" => "Bearer 123" }
        strategy = described_class.new(env, :user)

        expect(strategy).to(be_valid)
      end
    end

    context "when Authorization header is not valid" do
      it "returns false" do
        env = {}
        strategy = described_class.new(env, :user)

        expect(strategy).not_to(be_valid)
      end
    end
  end

  describe "#store?" do
    it "returns false" do
      expect(described_class.new({}).store?).to(eq(false))
    end
  end

  describe "#authenticate!" do
    context "when token is invalid" do
      let(:env) { { "HTTP_AUTHORIZATION" => "Bearer 123" } }
      let(:strategy) { described_class.new(env, :user) }

      before { strategy.authenticate! }

      it "fails authentication" do
        expect(strategy).not_to(be_successful)
      end

      it "halts authentication" do
        expect(strategy).to(be_halted)
      end
    end

    context "when token is valid" do
      include_context("with fixtures")

      let(:env) { { "HTTP_AUTHORIZATION" => "Bearer #{jwt_token}" } }
      let(:strategy) { described_class.new(env, :user) }
      let!(:user) do
        auth0_user_model.create(
          uid: "google-oauth2|101843459961769220909",
          email: Faker::Internet.unique.email,
          password: "password"
        )
      end

      before do
        Timecop.freeze(Time.zone.at(1644312671))
        VCR.use_cassette("auth0/user/google-oauth2|101843459961769220909") do
          strategy.authenticate!
        end
      end

      after { Timecop.return }

      it "successes authentication" do
        expect(strategy).to(be_successful)
      end

      it "logs in user returned by current mapping" do
        expect(strategy.user).to(eq(user))
      end
    end
  end
end
