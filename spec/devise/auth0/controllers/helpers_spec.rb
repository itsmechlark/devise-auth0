# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Devise::Auth0::Controllers::Helpers, type: :controller) do
  include_context("with fixtures")

  controller(ApplicationController) do
    before_action :authenticate_auth0!

    def index
    end
  end

  let(:current_auth0) { controller.current_auth0 }

  before { sign_in auth0_user }

  it { expect(controller.class.ancestors).to(include(described_class)) }

  it "proxy can?(action, resource) to current_auth0" do
    allow(current_auth0).to(receive(:can?).with(:read, User).and_return(true))
    controller.can?(:read, User)

    expect(current_auth0).to(have_received(:can?).with(:read, User))
  end

  it "proxy cannot?(action, resource) to current_auth0" do
    allow(current_auth0).to(receive(:cannot?).with(:read, User).and_return(false))
    controller.cannot?(:read, User)

    expect(current_auth0).to(have_received(:cannot?).with(:read, User))
  end

  describe "#authorize!" do
    it "raises an error if the user cannot perform the action" do
      allow(current_auth0).to(receive(:can?).with(:read, User).and_return(false))

      expect { controller.authorize!(:read, User) }.to(raise_error(Devise::Auth0::AccessDenied))
    end

    it "does not raise an error if the user can perform the action" do
      allow(current_auth0).to(receive(:can?).with(:read, User).and_return(true))

      expect { controller.authorize!(:read, User) }.not_to(raise_error)
    end
  end
end
