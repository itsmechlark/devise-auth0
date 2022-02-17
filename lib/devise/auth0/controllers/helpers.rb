# frozen_string_literal: true

require "devise/auth0/exceptions"

module Devise
  module Auth0
    module Controllers
      # Those helpers are convenience methods added to ApplicationController.
      module Helpers
        extend ActiveSupport::Concern

        included do
          if respond_to?(:devise_group)
            devise_group :auth0, contains: Devise.mappings.keys
          end

          if respond_to?(:helper_method)
            helper_method :can?, :cannot?
          end
        end

        def authorize!(*args)
          options = args.extract_options!
          message = options[:message]

          if cannot?(*args)
            raise AccessDenied.new(message, *args)
          end
          args
        end

        def can?(*args)
          !!current_auth0&.can?(*args)
        end

        def cannot?(*args)
          !!current_auth0&.cannot?(*args)
        end
      end
    end
  end
end
