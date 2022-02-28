# frozen_string_literal: true

module Devise
  class Auth0CallbacksController < Devise::OmniauthCallbacksController
    def callback
      user = resource_class.from_auth0_omniauth(request.env["omniauth.auth"])

      if user.persisted?
        set_flash_message(:notice, :success, kind: "Auth0") if is_navigational_format?
        sign_in_and_redirect(user, event: :authentication)
      else
        session["devise.auth0_data"] = request.env["omniauth.auth"].except(:extra)
        redirect_to(after_omniauth_callback_path_for(resource_name))
      end
    end

    private

    def after_omniauth_callback_path_for(scope)
      new_session_path(scope)
    end
  end
end
