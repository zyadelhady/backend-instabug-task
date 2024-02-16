module Api
  module V1
    class ChatsController < ApplicationController

      def initialize
        @columns = Chat.attribute_names - ['id', 'application_id']
      end

      def create
        application = Application.select(:id).find_by(token: params[:application_token])

        if !application.present?
          return render json: {errors: "No Application Found"},status: :not_found
        end

        puts application.redis_key

        new_chat_num = REDIS.incr(application.redis_key)

        chat  = Chat.new({ application_id: application.id,number: new_chat_num })

        if chat.save
          render json: {data: chat.slice(@columns)},status: :ok
        else
          render json: {errors: chat.errors},status: :unprocessable_entity
        end
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
