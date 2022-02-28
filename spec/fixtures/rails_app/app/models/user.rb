# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :auth0,
    auth0_options: { omniauth: false, email_domains_blocklist: ["firstcircle.com"] }

  validates_presence_of :email
end
