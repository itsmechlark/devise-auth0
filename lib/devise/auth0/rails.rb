# frozen_string_literal: true

require "omniauth-auth0"
require "omniauth/rails_csrf_protection"

require "devise/auth0/controllers/helpers"

module Devise
  class Engine < ::Rails::Engine
    initializer "devise.auth0", after: :load_config_initializers, before: :build_middleware_stack do |app|
      config = Devise::Auth0.config
      if config.omniauth
        app.middleware.use(::OmniAuth::Builder) do
          provider :auth0,
            config.client_id,
            config.client_secret,
            config.domain, {
              callback_path: config.callback_path,
              authorize_params: {
                audience: config.aud,
                scope: config.scope,
              },
            }
        end
      end

      ActiveSupport.on_load(:action_controller) do
        include Devise::Auth0::Controllers::Helpers
      end
    end
  end
end
