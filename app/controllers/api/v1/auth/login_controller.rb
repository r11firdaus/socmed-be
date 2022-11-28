module Api::V1::Auth
  class LoginController < ApplicationController
    def create
      check_email = User.find_by(email: params[:email])
      if check_email && check_email.authenticate(params[:password])
        token = JWT.encode(params[:email], 'HS256')
        update_token(check_email, token)
      else
        render json: { message: 'email or password invalid!' }, status: 401
      end
    end

    private
    def update_token(user, token)
      if user.update(token: token)
        render json: { message: 'success!', data: { id: user.id, token: token, email: user.email } }
      else
        render json: { message: 'error, please try again' }, status: 500
      end
    end
  end 
end