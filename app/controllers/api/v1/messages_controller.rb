module Api::V1
  class MessagesController < ApplicationController
    before_action :set_message, only: %i[ edit destroy ]

    def index
      if check_user(params[:user_id])
        arrayChats = []
        chats = Message.all_chats(params[:user_id]).group_by{ |x| x[:unique_id] }

        chats.each do |key, val|
          arrayChats.push({ "#{key}": val })
        end
        
        # newChats = chats.group_by{ |x| x[:unique_id] }.values}
        render json: { data: (chats ? arrayChats : chats.errors) }
      else
        render json: { message: 'unauthorized' }, status: 401
      end
    end
  
    # GET /messages/1 or /messages/1.json
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
  
    # POST /messages or /messages.json
    def create
      msg = Message.direct_message(message_params)&.first
      if check_user(params[:user_id])
        if msg
          render json: { data: msg }
          ActionCable.server.broadcast "chat_channel_for_#{msg["receiver_id"]}", { data: msg, sender: @user.email }
          # opponent = msg.unique_id.split("+").select { |x| x != msg.user_id.to_s }.first
        else
          render json: { message: 'error'}, status: :unprocessable_entity
        end
      else
        render json: { message: 'unauthorized' }, status: 401
      end
    end
  
    # PATCH/PUT /messages/1 or /messages/1.json
    def update
      update_params = {
        unique_id: params[:id],
        receiver_id: params[:receiver_id],
        status: 3,
      }

      msg = Message.read_messages(update_params)
      if msg
        opponent = params[:id].split("+").select { |x| x != params[:receiver_id].to_s }.first
        ActionCable.server.broadcast "chat_channel_for_#{opponent}", { data: { unique_id: params[:id] }, type: 'update' }
        render json: { data: 'readed!' }
      else
        render json: { message: 'error'}, status: :unprocessable_entity
      end
    end
  
    # DELETE /messages/1 or /messages/1.json
    def destroy
      @message.destroy
  
      respond_to do |format|
        format.html { redirect_to messages_url, notice: "Message was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_message
        @message = Message.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def message_params
        params.require(:message).permit(:user_id, :unique_id, :content, :receiver_id)
      end
  end
end
