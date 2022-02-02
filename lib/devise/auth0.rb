# frozen_string_literal: true

require "devise"

# Authentication library
module Devise
  # Auth0 extension for devise
  module Auth0
    extend Dry::Configurable
  end
end
