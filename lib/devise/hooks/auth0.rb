# frozen_string_literal: true

Warden::Manager.before_logout do |record, _warden, _options|
  if record.respond_to?(:auth0_id)
    Devise::Auth0.logout(record)
  end
end
