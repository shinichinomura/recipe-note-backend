# frozen_string_literal: true

class Secure::LogoutController < Secure::ApplicationController
  def logout
    @current_user.update_column(:jti, SecureRandom.uuid)

    render json: {
      status: "success"
    }
  end
end
