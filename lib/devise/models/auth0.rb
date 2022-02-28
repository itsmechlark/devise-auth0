# frozen_string_literal: true

module Devise
  module Models
    module Auth0
      extend ActiveSupport::Concern

      def self.required_fields(klass)
        []
      end

      def can?(action, resource_class = nil)
        scope = [action]
        if resource_class.is_a?(String)
          scope << resource_class
        elsif resource_class
          resource_name = resource_class.name.underscore.split("/")
          resource_name[-1] = resource_name[-1].pluralize
          scope << resource_name.join("/")
        end
        auth0_scopes.include?(scope.join(":"))
      end

      # Convenience method which works the same as "can?" but returns the opposite value.
      #
      #   cannot? :destroy, @project
      #
      def cannot?(*args)
        !can?(*args)
      end

      def auth0_scopes=(scopes)
        @auth0_scopes = scopes
      end

      def auth0_id
        "#{provider}|#{uid}"
      end

      def after_auth0_token_authentication(token)
      end

      def after_auth0_omniauth_authentication(auth)
      end

      private

      def auth0_scopes
        return @auth0_scopes unless @auth0_scopes.nil?

        @auth0_scopes ||= if bot?
          self.class.auth0_client.client_grants(
            client_id: uid,
            audience: self.class.auth0_config.aud
          ).first.try(:[], "scope")
        else
          self.class.auth0_client.get_user_permissions(auth0_id).select do |permission|
            permission["resource_server_identifier"] == self.class.auth0_config.aud
          end.map do |permission|
            permission["permission_name"]
          end
        end
      end

      module ClassMethods
        Devise::Models.config(self, :auth0_config)

        def from_auth0_token(token)
          user = where(provider: token.provider, uid: token.uid).first_or_create do |user|
            user.email = token.user["email"] if user.respond_to?(:email=)
            user.password = Devise.friendly_token[0, 20] if user.respond_to?(:password=)
            user.bot = token.bot? if user.respond_to?(:bot=)
            user.after_auth0_token_authentication(token)
          end
          user.auth0_scopes = token.scopes
          user
        end

        def from_auth0_omniauth(auth)
          uid = auth.uid.include?("|") ? auth.uid.split("|").last : auth.uid
          where(provider: auth.provider, uid: uid).first_or_create do |user|
            user.email = auth.info.email if user.respond_to?(:email=)
            user.password = Devise.friendly_token[0, 20] if user.respond_to?(:password=)
            user.after_auth0_omniauth_authentication(auth)
          end
        end

        def auth0_config
          return @auth0_config unless @auth0_config.nil?

          @auth0_config ||= ::Devise.auth0.dup
        end

        def auth0_client
          @auth0_client ||= ::Devise::Auth0::Client.new(auth0_config)
        end
      end
    end
  end
end
