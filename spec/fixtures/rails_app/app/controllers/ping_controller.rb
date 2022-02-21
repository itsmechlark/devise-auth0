# frozen_string_literal: true

class PingController < ApplicationController
  def index
    render(json: { message: "pong", uid: current_auth0.uid })
  end
end
