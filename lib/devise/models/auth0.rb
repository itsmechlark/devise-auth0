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

      private

      def auth0_scopes
        return @auth0_scopes unless @auth0_scopes.nil?

        @auth0_scopes ||= if bot?
          ::Devise::Auth0.client.client_grants(
            client_id: uid,
            audience: ::Devise::Auth0.config.aud
          ).first.try(:[], "scope")
        else
          ::Devise::Auth0.client.get_user_permissions(uid).select do |permission|
            permission["resource_server_identifier"] == ::Devise::Auth0.config.aud
          end.map do |permission|
            permission["permission_name"]
          end
        end
      end

      module ClassMethods
        def from_auth0_token(token)
          user = where(uid: token.user_id).first_or_create do |user|
            user.email = token.user["email"] if user.respond_to?(:email=)
            user.password = Devise.friendly_token[0, 20] if user.respond_to?(:password=)
            user.bot = token.bot? if user.respond_to?(:bot=)
          end
          user.auth0_scopes = token.scopes
          user
        end
      end
    end
  end
end
