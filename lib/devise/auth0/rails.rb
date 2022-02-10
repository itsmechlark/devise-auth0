# frozen_string_literal: true

module Devise
  class Engine < ::Rails::Engine
    config.devise = Devise

    initializer "devise.auth0", after: :load_config_initializers, before: :build_middleware_stack do |app|
      config = Devise::Auth0.config
      if config.omniauth
        app.config.middleware.use OmniAuth::Builder do
          provider :auth0, config.client_id, config.client_secret, config.domain, {
            authorize_params: {
              audience: config.aud,
              scope: 'openid',
            }
          }
        end
      end
    end
  end
end