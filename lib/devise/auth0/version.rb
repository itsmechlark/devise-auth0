# frozen_string_literal: true

module Devise
  module Auth0
    VERSION = "1.2.2"  # x-release-please-version

    class << self
      def gem_version
        Gem::Version.new(VERSION)
      end
    end
  end
end
