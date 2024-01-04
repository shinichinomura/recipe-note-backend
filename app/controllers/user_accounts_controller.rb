# frozen_string_literal: true

class UserAccountsController < ApplicationController
  def create
    email = params[:email]
    password = params[:password]
    display_name = params[:display_name]

    user_account = UserAccount.new(
      email: email,
      password: password,
      display_name: display_name,
      registered_at: Time.now,
      jti: SecureRandom.uuid
    )

    if user_account.save
      render json: {
        status: "success",
        user_account: {
          id: user_account.id,
          display_name: user_account.display_name
        }
      }
    else
      render json: {
        status: "error",
        errorMessages: user_account.errors.full_messages
      }
    end
  end
end
