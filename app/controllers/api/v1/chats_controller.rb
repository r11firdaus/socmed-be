module Api::V1
  class ChatsController < ApplicationController
    before_action :set_chat, only: %i[ destroy ]
  
    # GET /chats or /chats.json
    def index
      if check_user(params[:user_id])
        chats = Chat.all_chats(params[:user_id])
        # render json: chats.to_json(include: [:messages, :user] )
        render json: { chats: (chats ? chats : chats.errors) }
      else
        render json: { message: 'unauthorized' }, status: 401
      end
    end
  
    # GET /chats/1 or /chats/1.json
    def show
      if check_user(params[:user_id])
        chats = Message.direct_chats(params[:user_id], params[:id])
        render json: { message: (chats ? chats : chats.errors) }
      else
        render json: { message: 'unauthorized' }, status: 401
      end
    end
  
    # DELETE /chats/1 or /chats/1.json
    def destroy
      @chat.destroy
  
      respond_to do |format|
        format.html { redirect_to chats_url, notice: "Chat was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_chat
        @chat = Chat.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def chat_params
        params.require(:chat).permit(:user_1_id, :user_2_id, :content)
      end
  end
end
