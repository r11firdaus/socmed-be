module Api::V1::Auth
  class SignupController < ApplicationController
    def create
      check_email = User.find_by(email: params[:email].downcase)
      if check_email
        render json: { message: 'email has been taken!' }, status: 401
      else
        create_user(params[:email], params[:password])
      end
    end

    private
    def create_user(email, password)
      if User.create(email: email, password: password)
        render json: { message: 'success!' }
      else
        render json: { message: 'error, please try again' }, status: 500
      end
    end
  end
end