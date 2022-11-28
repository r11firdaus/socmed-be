module Api::V1
  class PostsController < ApplicationController
    before_action :set_post, only: %i[ show edit update destroy ]
  
    # GET /posts/1 or /posts/1.json
    def show
      if @post.present?
        render json: { message: 'success', data: @post }
      else
        render json: { message: @post.errors }, status: :unprocessable_entity
      end
    end
  
    # POST /posts or /posts.json
    def create
      if check_user(params[:user_id])
        post = Post.new(post_params)
        if post.save
          render json: { message: 'success', data: post}
        else
          render json: { message: post.errors }, status: :unprocessable_entity  
        end
      else
        render json: { message: 'unauthorized' }, status: 401
      end
    end
  
    # PATCH/PUT /posts/1 or /posts/1.json
    def update
      if check_user(params[:user_id]) && @post.user_id.to_i == params[:user_id].to_i
        if @post.update(post_params)
          render json: { message: 'success', data: @post}
        else
          render json: { message: @post.errors }, status: :unprocessable_entity  
        end
      else
        render json: { message: 'unauthorized' }, status: 401
      end
    end
  
    # DELETE /posts/1 or /posts/1.json
    def destroy
      if check_user(params[:user_id]) && @post.user_id.to_i == params[:user_id].to_i
        if @post.destroy
          render json: { message: 'success'}
        else
          render json: { message: @post.errors }, status: :unprocessable_entity  
        end
      else
        render json: { message: 'unauthorized' }, status: 401
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_post
        @post = Post.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def post_params
        {
          content: params[:content],
          img_url: params[:img_url], 
          user_id: params[:user_id]
        }
      end
  end
end
