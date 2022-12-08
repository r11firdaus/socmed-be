module Api::V1
  class MessagesController < ApplicationController
    before_action :set_message, only: %i[ edit update destroy ]

    def index
      if check_user(params[:user_id])
        chats = Message.all_chats(params[:user_id])
        newChats = chats.group_by{ |x| x[:unique_id] }.values
        render json: { data: (chats ? newChats : chats.errors) }
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
      msg = Message.new(message_params)
      if msg.save
        render json: { data: msg }
        ActionCable.server.broadcast "chat_channel_for_#{msg.receiver_id}", msg
        # opponent = msg.unique_id.split("+").select { |x| x != msg.user_id.to_s }.first
        # ActionCable.server.broadcast "chat_channel_for_#{opponent}", msg
      else
        render json: { message: 'error'}, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /messages/1 or /messages/1.json
    def update
      respond_to do |format|
        if @message.update(message_params)
          format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
          format.json { render :show, status: :ok, location: @message }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
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
