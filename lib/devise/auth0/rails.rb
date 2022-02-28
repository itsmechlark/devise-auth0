# frozen_string_literal: true

require "omniauth-auth0"
require "omniauth/rails_csrf_protection"

require "devise/auth0/rails/routes"
require "devise/auth0/controllers/helpers"

module Devise
  module Auth0
    class Engine < ::Rails::Engine
      initializer "devise.auth0", before: "devise.omniauth" do |_app|
        config = Devise.auth0
        if config.omniauth
          Devise.setup do |devise|
            devise.omniauth(:auth0,
              config.client_id,
              config.client_secret,
              config.domain, {
                authorize_params: {
                  audience: config.aud,
                  scope: config.scope,
                },
              })
          end
        end

        ActiveSupport.on_load(:action_controller) do
          include Devise::Auth0::Controllers::Helpers
        end
      end
    end
  end
end
