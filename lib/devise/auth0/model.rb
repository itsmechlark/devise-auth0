# frozen_string_literal: true

module Devise
  module Models
    module Auth0
      extend ActiveSupport::Concern

      def self.required_fields(klass)
        []
      end

      module ClassMethods
        def from_auth0_token(token)
          where(uid: token.user_id).first_or_create do |user|
            user.email = token.user["email"] if user.respond_to?(:email=)
            user.password = Devise.friendly_token[0, 20] if user.respond_to?(:password=)
          end
        end
      end
    end
  end
end
