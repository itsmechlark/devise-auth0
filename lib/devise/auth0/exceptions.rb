# frozen_string_literal: true

module Devise
  module Auth0
    # A general CanCan exception
    class Error < StandardError; end

    class AccessDenied < Error
      attr_reader :action, :subject

      def initialize(message = nil, action = nil, resource_class = nil)
        @message = message.presence || I18n.t(:"unauthorized.default",
          default: "You are not authorized to access this page.")
        @action = action
        @resource_class = resource_class

        super(@message)
      end
    end
  end
end
