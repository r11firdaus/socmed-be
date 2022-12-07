module Api::V1
  class MessagesController < ApplicationController
    before_action :set_message, only: %i[ show edit update destroy ]
  
    # GET /messages/1 or /messages/1.json
    def show
    end
  
    # POST /messages or /messages.json
    def create
      msg = Message.new(message_params)
      if msg.save
        opponent = msg.unique_id.split("+").select { |x| x != msg.user_id.to_s }.first
        render json: { data: msg }
        ActionCable.server.broadcast "chat_channel_for_#{opponent}", msg
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
        { user_id: params[:user_id], unique_id: params[:unique_id], content: params[:content] }
      end
  end
end
