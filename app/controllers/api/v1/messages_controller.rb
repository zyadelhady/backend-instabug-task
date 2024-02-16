module Api
  module V1
    class MessagesController < ApplicationController
      def initialize
        @columns = Message.attribute_names - ['id', 'chat_id']
      end

      def index
        messages = Message.select(@columns).joins(chat: :application).where(applications: { token: params[:application_token] },chats: {number: params[:chat_number]})
        render json: { data: messages }, status: :ok
      end

      def show
        message = Message.select(@columns).joins(chat: :application).where(applications: { token: params[:application_token] },chats: {number: params[:chat_number]},number: params[:number]).limit(1).first()
        if message
          render json: { data: message }, status: :ok
        else
          render json: { errors: "Message not found" }, status: :not_found
        end
      end

      def create
        chat = Chat.select([:id,:number,:application_id]).includes(:messages).joins(:application).where(applications: { token: params[:application_token] },number: params[:chat_number]).limit(1).first()

        if !chat.present?
          return render json: {errors: "No Chat Found"},status: :not_found
        end

        / we can also use SETNX instead of this /

        current_redis_number = REDIS.get(chat.redis_key)

        if current_redis_number.nil?
          lock = $red_lock.lock("messages",2000)
          REDIS.set(chat.redis_key,chat.messages.maximum(:number).to_i)
          $red_lock.unlock(lock)
        end

        new_message_num = REDIS.incr(chat.redis_key)

        message = chat.messages.new({content: message_params[:content], number: new_message_num })

        $kafka_producer.produce(message.attributes.to_json, topic: "messages")
        $kafka_producer.deliver_messages

        render json: { data: message.slice(:number) }, status: :ok
      end

      def update
        message = Message.joins(chat: :application).where(applications: { token: params[:application_token] },chats: {number: params[:chat_number]},number: params[:number]).limit(1).first()
        if message
          if message.update(message_params)
            render json: { data: message.slice(@columns) }, status: :ok
          else
            render json: { errors: message.errors }, status: :unprocessable_entity
          end
        else
          render json: { errors: "Message not found" }, status: :not_found
        end
      end

      def destroy
        message = Message.joins(chat: :application).where(applications: { token: params[:application_token] },chats: {number: params[:chat_number]},number: params[:number]).limit(1).first()
        if message
          if message.destroy
            render :no_content
          else
            render json: { errors: message.errors }, status: :unprocessable_entity
          end
        else
          render json: { errors: "Message not found" }, status: :not_found
        end
      end

      private

      def message_params
        params.require(:message).permit(:content)
      end
    end
  end
end
