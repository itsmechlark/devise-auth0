# frozen_string_literal: true

require "spec_helper"

RSpec.describe("Logout Auth0", type: :request) do
  include_context("with integration")
  include_context("with fixtures")

  before do
    sign_in(auth0_user)
    allow(Devise::Auth0).to(receive(:logout))
  end

  it "call #logout" do
    delete(destroy_user_session_path)

    expect(Devise::Auth0).to(have_received(:logout))
  end
end
