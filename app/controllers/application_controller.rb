class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  def check_user(user_id)
    @current_user = User.find(user_id)
    @current_user.token == request.headers["HTTP_TOKEN"]
  end
end
