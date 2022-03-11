# frozen_string_literal: true

require "auth0"

module Devise
  module Auth0
    class Client < ::Auth0::Client
      def initialize(config)
        super(
          client_id: config.client_id,
          client_secret: config.client_secret,
          domain: config.domain,
        )
      end
    end
  end
end
