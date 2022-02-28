# frozen_string_literal: true

class User < ApplicationRecord
    devise :database_authenticatable, :auth0

    validates_presence_of :email
end
