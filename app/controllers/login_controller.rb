# frozen_string_literal: true

class LoginController < ApplicationController
  def login
    user_account = UserAccount.find_by(email: params[:email])

    if user_account && user_account.authenticate(params[:password])
      jti = user_account.jti
      exp = (Time.now + 24.hour).to_i
      payload = {
        jti: jti,
        exp: exp,
        user_account_id: user_account.id
      }
      token = JWT.encode(payload, Rails.application.credentials[:secret_key_base])

      render json: {
        status: "success",
        token: token,
        user_account: {
          id: user_account.id,
          display_name: user_account.display_name
        }
      }
    else
      render json: {
        status: "error",
        errorMessages: ["メールアドレスまたはパスワードが正しくありません"]
      }
    end
  end
end
