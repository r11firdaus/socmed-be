module Api::V1::Auth
  class LoginController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      check_email = User.find_by(email: params[:email])
      if check_email && check_email.authenticate(params[:password])
        token = JWT.encode(params[:email], 'HS256')
        update_token(check_email, token)
      else
        render json: { data: 'email or password invalid!' }, status: 401
      end
    end

    private
    def update_token(user, token)
      if user.update(token: token)
        render json: { data: 'success!', token: token, email: user.email }
      else
        render json: { data: 'error, please try again' }, status: 500
      end
    end
  end
end