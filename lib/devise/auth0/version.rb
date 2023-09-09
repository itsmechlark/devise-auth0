# frozen_string_literal: true

module Devise
  module Auth0
    VERSION = "1.1.0"

    class << self
      def gem_version
        Gem::Version.new(VERSION)
      end
    end
  end
end
