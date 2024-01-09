# frozen_string_literal: true

class Secure::UserAccountsController < Secure::ApplicationController
  def me
    render json: {
      status: "success",
      user_account: {
        id: @current_user.id,
        display_name: @current_user.display_name
      }
    }
  end
end
