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
      split_user_id = params[:id].split("+")
      if split_user_id.length == 2
        chats = Message.direct_chats(split_user_id[0], split_user_id[1])
        unique_id = chats.length > 0 ? chats.first.unique_id : params[:id]
        render json: { unique_id: unique_id, data: (chats ? chats : chats.errors) }
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
