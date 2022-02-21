# frozen_string_literal: true

RSpec.shared_context("with integration") do
  def auth_headers(auth)
    {
      "Authorization" => auth,
      "Accept" => "application/json",
    }
  end

  def get_with_auth(path, auth)
    get(path, headers: auth_headers(auth))
  end
end
