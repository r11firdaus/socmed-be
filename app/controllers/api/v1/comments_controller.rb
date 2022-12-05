module Api::V1
  class CommentsController < ApplicationController
    before_action :set_comment, only: %i[ show edit update destroy ]
  
    # GET /comments/ or /comments/.json
    def index
      comments = Comment.joins(:user).select("comments.*, users.email").where(post_id: params[:post_id]).order("id ASC")
      render json: { data: comments }
    end

    # GET /comments/1 or /comments/1.json
    def show 
      render json: { data: @comment }
    end

    # GET /comments/1/edit
    def edit
    end
  
    # POST /comments or /comments.json
    def create
      if check_user(params[:user_id])
        comment = Comment.new(comment_params)
  
        if comment.save
          render json: { message: 'success', data: comment }
          user = User.find(params[:user_id])
          ActionCable.server.broadcast 'comment_channel', {comment: comment, email: user.email}
        else
          render json: { message: comment.errors }, status: :unprocessable_entity  
        end
      else
        render json: { message: 'unauthorized' }, status: 401
      end
    end
  
    # PATCH/PUT /comments/1 or /comments/1.json
    def update
      respond_to do |format|
        if @comment.update(comment_params)
          format.html { redirect_to comment_url(@comment), notice: "Comment was successfully updated." }
          format.json { render :show, status: :ok, location: @comment }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /comments/1 or /comments/1.json
    def destroy
      @comment.destroy
  
      respond_to do |format|
        format.html { redirect_to comments_url, notice: "Comment was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_comment
        @comment = Comment.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def comment_params
        {
          post_id: params[:post_id],
          user_id: params[:user_id],
          content: params[:content]
        }
      end
  end
end
