# frozen_string_literal: true

class AdminUser < ApplicationRecord
  devise :database_authenticatable, :auth0, auth0_options: { email_domains_allowlist: ["firstcircle.com"] }

  validates_presence_of :email
end
