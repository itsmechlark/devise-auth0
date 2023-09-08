# frozen_string_literal: true

module Devise
  module Auth0
    class << self
      def gem_version
        Gem::Version.new(VERSION::STRING)
      end
    end

    module VERSION
      MAJOR = 1
      MINOR = 0
      TINY  = 0
      PRE   = "rc10"

      STRING = [MAJOR, MINOR, TINY, PRE].compact.join(".")
    end
  end
end
