# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Devise::Models::Auth0) do
  include_context("with fixtures")

  let(:model) { auth0_user_model }
  let(:user) { auth0_user }

  describe ".required_fields" do
    it { expect(described_class.required_fields(model)).to(eq([])) }
  end

  describe "#email_domain_allowed" do
    let(:model) { auth0_admin_user_model }

    context "with not allowed domain" do
      subject(:user) do
        model.new(
          provider: "auth0",
          uid: Faker::Internet.unique.uuid,
          email: Faker::Internet.unique.email,
          password: "password",
        )
      end

      it { is_expected.not_to(be_valid) }

      it "adds error" do
        user.valid?
        expect(user.errors[:email].join).to(include("email.not_allowed"))
      end
    end

    context "with allowed domain" do
      subject(:user) do
        model.new(
          provider: "auth0",
          uid: Faker::Internet.unique.uuid,
          email: auth0_admin_user_email,
          password: "password",
        )
      end

      it { is_expected.to(be_valid) }
    end

    context "with no allowed list" do
      subject(:user) do
        model.new(
          provider: "auth0",
          uid: Faker::Internet.unique.uuid,
          email: Faker::Internet.unique.email,
          password: "password",
        )
      end

      let(:model) { auth0_user_model }

      it { is_expected.to(be_valid) }
    end
  end

  describe "#email_domain_disallowed" do
    let(:model) { auth0_user_model }

    context "with disallowed domain" do
      subject(:user) do
        model.new(
          provider: "auth0",
          uid: Faker::Internet.unique.uuid,
          email: auth0_admin_user_email,
          password: "password",
        )
      end

      it { is_expected.not_to(be_valid) }

      it "adds error" do
        user.valid?
        expect(user.errors[:email].join).to(include("email.not_allowed"))
      end
    end

    context "with allowed domain" do
      subject(:user) do
        model.new(
          provider: "auth0",
          uid: Faker::Internet.unique.uuid,
          email: Faker::Internet.unique.email,
          password: "password",
        )
      end

      it { is_expected.to(be_valid) }
    end

    context "with no blocklist" do
      subject(:user) do
        model.new(
          provider: "auth0",
          uid: Faker::Internet.unique.uuid,
          email: auth0_admin_user_email,
          password: "password",
        )
      end

      let(:model) { auth0_admin_user_model }

      it { is_expected.to(be_valid) }
    end
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
    context "when cache" do
      before { user.auth0_scopes = ["read:users", "update", "read:user/roles"] }

      it "returns cached value" do
        expect(user.auth0_scopes).to(eq(["read:users", "update", "read:user/roles"]))
      end
    end

    context "when user" do
      subject(:scopes) do
        VCR.use_cassette("auth0/user/google-oauth2|101843459961769220909/permissions") do
          user.send(:auth0_scopes)
        end
      end

      let(:user) do
        auth0_user_model.create(
          provider: "google-oauth2",
          uid: "101843459961769220909",
          email: "someone@firstcircle.io",
          password: "password",
          bot: false,
        )
      end

      it { is_expected.to(contain_exactly("create:leads", "delete:leads")) }
    end

    context "when unknown user email" do
      subject(:scopes) do
        VCR.use_cassette("auth0/user/google-oauth2|101843459961769220909/permissions") do
          user.send(:auth0_scopes)
        end
      end

      let(:user) do
        auth0_user_model.create(
          provider: "google-oauth2",
          uid: "101843459961769220909",
          email: "unknown@firstcircle.io",
          password: "password",
          bot: false,
        )
      end

      it { is_expected.to(be_empty) }
    end

    context "when bot" do
      subject(:scopes) do
        VCR.use_cassette("auth0/grants/UDuyRC6XeVr9eCPIrOP0dgIL0xTLs33f") do
          bot.send(:auth0_scopes)
        end
      end

      let(:bot) do
        auth0_user_model.create(
          provider: "auth0",
          uid: "UDuyRC6XeVr9eCPIrOP0dgIL0xTLs33f",
          email: Faker::Internet.unique.email,
          password: "password",
          bot: true,
        )
      end

      it { is_expected.to(contain_exactly("read:leads")) }
    end
  end

  describe "#set_auth_id" do
    subject(:user) { auth0_user }

    let(:google) { Faker::Omniauth.google }

    it "sets auth0_id when not match" do
      user.send(:set_auth_id, google[:provider], google[:uid])

      expect(user.auth0_id).to(eq("#{google[:provider]}|#{google[:uid]}"))
    end

    it "no call save when match" do
      expect do
        user.send(:set_auth_id, user.provider, user.uid)
      end.not_to(change(user, :updated_at))
    end
  end

  describe(".from_auth0_token(token)") do
    let(:user) { model.from_auth0_token(token) }
    let(:token) do
      instance_double(
        "Token",
        provider: auth0_user.provider,
        uid: auth0_user.uid,
        auth0_id: auth0_user.auth0_id,
        user: { email: Faker::Internet.unique.email },
        scopes: ["openid", "profile", "email"],
        permissions: ["read:leads", "create:leads", "delete:leads"],
        bot?: false,
      )
    end

    it "finds record which has given `user_id` as `uid`" do
      expect(model.from_auth0_token(token)).to(eq(auth0_user))
    end

    it "sets scopes from permissions" do
      expect(user.auth0_scopes).to(
        contain_exactly("openid", "profile", "email", "read:leads", "create:leads", "delete:leads"),
      )
    end

    context "when email does match" do
      let(:uid) { Faker::Internet.unique.uuid }
      let(:auth0_id) { "google-oauth2|#{uid}" }
      let(:token) do
        instance_double(
          "Token",
          provider: "google-oauth2",
          uid: uid,
          auth0_id: auth0_id,
          user: { "email" => auth0_user.email },
          scopes: [],
          permissions: [],
          bot?: false,
        )
      end

      it { expect(user).to(be_persisted) }
      it { expect(user.email).to(eq(token.user["email"])) }
      it { expect(user.auth0_id).to(eq(auth0_id)) }
    end

    context "when uid does not match" do
      let(:token) do
        uid = Faker::Internet.unique.uuid

        instance_double(
          "Token",
          provider: "google-oauth2",
          uid: uid,
          auth0_id: "google-oauth2|#{uid}",
          user: { "email" => Faker::Internet.unique.email },
          scopes: [],
          permissions: [],
          bot?: false,
        )
      end

      it { expect(user).to(be_persisted) }
      it { expect(user.auth0_id).to(eq(token.auth0_id)) }
      it { expect(user.email).to(eq(token.user["email"])) }

      it "call #after_auth0_token_created" do
        expect_any_instance_of(model).to(receive(:after_auth0_token_created).with(token))
        model.from_auth0_token(token)
      end

      it "call #after_auth0_token" do
        expect_any_instance_of(model).to(receive(:after_auth0_token).with(token))
        model.from_auth0_token(token)
      end
    end

    context "when bot" do
      let(:token) do
        uid = Faker::Internet.unique.uuid

        instance_double(
          "Token",
          provider: "auth0",
          uid: uid,
          auth0_id: "auth0|#{uid}",
          user: { "email" => "#{uid}@#{Devise.auth0.domain}" },
          scopes: [],
          permissions: [],
          bot?: true,
        )
      end

      before { allow(token).to(receive(:bot?).and_return(true)) }

      it { expect(user).to(be_persisted) }
      it { expect(user).to(be_bot) }
    end
  end

  describe(".from_auth0_omniauth(auth)") do
    let(:model) { auth0_admin_user_model }
    let(:user) { model.from_auth0_omniauth(auth) }
    let(:auth) do
      info = instance_double(
        "AuthInfo",
        email: auth0_admin_user.email,
      )

      instance_double(
        "Auth",
        provider: auth0_admin_user.provider,
        uid: "auth0|#{auth0_admin_user.uid}",
        info: info,
      )
    end

    it "finds record which has given `user_id` as `uid`" do
      expect(model.from_auth0_omniauth(auth)).to(eq(auth0_admin_user))
    end

    context "when email does match" do
      let(:uid) { Faker::Internet.unique.uuid }
      let(:auth) do
        info = instance_double(
          "AuthInfo",
          email: auth0_admin_user.email,
        )

        instance_double(
          "Auth",
          provider: "auth0",
          uid: "auth0|#{uid}",
          info: info,
        )
      end

      it { expect(user).to(be_persisted) }
      it { expect(user.email).to(eq(auth.info.email)) }
      it { expect(user.auth0_id).to(eq("auth0|#{uid}")) }
    end

    context "when uid does not match" do
      let(:auth) do
        uid = Faker::Internet.unique.uuid

        info = instance_double(
          "AuthInfo",
          email: auth0_admin_user_email,
        )

        instance_double(
          "Auth",
          provider: "auth0",
          uid: uid,
          info: info,
        )
      end

      it { expect(user).to(be_persisted) }
      it { expect(user.provider).to(eq(auth.provider)) }
      it { expect(user.uid).to(eq(auth.uid)) }
      it { expect(user.email).to(eq(auth.info.email)) }

      it "call #after_auth0_omniauth_created" do
        expect_any_instance_of(model).to(receive(:after_auth0_omniauth_created).with(auth))
        model.from_auth0_omniauth(auth)
      end

      it "call #after_auth0_omniauth" do
        expect_any_instance_of(model).to(receive(:after_auth0_omniauth).with(auth))
        model.from_auth0_omniauth(auth)
      end
    end
  end
end
