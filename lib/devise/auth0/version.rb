# frozen_string_literal: true

module Devise
  module Auth0
    VERSION = "1.0.0".freeze

    class << self
      def gem_version
        Gem::Version.new(VERSION)
      end
    end
  end
end
