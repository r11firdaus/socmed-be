module Api::V1
  class UsersController < ApplicationController
    before_action :set_user, only: %i[ show ]
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
