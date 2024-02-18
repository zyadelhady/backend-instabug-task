module Api
  module V1
    class ChatsController < ApplicationController

      def initialize
        @columns = Chat.attribute_names - ['id', 'application_id']
        @topic = "chats"
      end

      def create
        application = Application.select(:id,:chats_count).includes(:chats).find_by(token: params[:application_token])

        if !application.present?
          return render json: {errors: "No Application Found"},status: :not_found
        end

        / we can also use SETNX instead of this /

        current_redis_number = REDIS.get(application.redis_key)

        if current_redis_number.nil?
          lock = $red_lock.lock("chats",2000)
          REDIS.set(application.redis_key,application.chats.maximum(:number).to_i)
          $red_lock.unlock(lock)
        end

        new_chat_num = REDIS.incr(application.redis_key)

        chat  = Chat.new({ application_id: application.id,number: new_chat_num })

        $kafka_producer.produce(chat.attributes.to_json, topic: @topic)
        $kafka_producer.deliver_messages

        render json: { data: chat.slice(:number, :messages_count) }, status: :ok
      end

      def index
        chats = Chat.select(@columns).joins(:application).where(applications: { token: params[:application_token] })
        render json: {data: chats}
      end

      def show
        chat = Chat.select(@columns).joins(:application).where(applications: { token: params[:application_token] },number: params[:number]).limit(1).first()
        render json: {data: chat},status: :ok
      end

      def update
          render status: :bad_request
      end

      def destroy
        chat = Chat.joins(:application).where(applications: { token: params[:application_token] },number: params[:number]).limit(1).first()

        if chat
          if chat.destroy
            render :no_content
          else
          render json: {errors: chat.errors},status: :unprocessable_entity
          end
        else
          render json: {errors: "Chat not found"},status: :not_found
        end
      end

    end
  end
end
