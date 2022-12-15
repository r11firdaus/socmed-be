module Api::V1
  class UserController < ApplicationController
    def show      
      if @user.present?
        data = { email: @user[:email], id: @user[:id] }
        render json: { data: data }
      else
        render json: { message: 'user not found' }, status: 404
      end
    end

    private
    def set_user
      @user = User.find(params[:id])
    end
  end
end
