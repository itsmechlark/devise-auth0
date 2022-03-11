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
                  audience: config.aud.join(","),
                  scope: config.scope,
                },
              })
          end

          # Patches the existing devise failure app to ensure a right mapping is used.
          # Read more: devise/omniauth.rb
          ::OmniAuth.config.on_failure = proc do |env|
            env["devise.mapping"] = ::Devise::Mapping.find_by_path!(env["PATH_INFO"], :fullpath)
            controller_name  = ActiveSupport::Inflector.camelize(env["devise.mapping"].controllers[:omniauth_callbacks])
            controller_klass = ActiveSupport::Inflector.constantize("#{controller_name}Controller")
            controller_klass.action(:failure).call(env)
          end
        end

        ActiveSupport.on_load(:action_controller) do
          include Devise::Auth0::Controllers::Helpers
        end
      end
    end
  end
end
