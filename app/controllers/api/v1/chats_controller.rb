module Api
  module V1
    class ChatsController < ApplicationController

      def initialize
        @columns = Chat.attribute_names - ['id']
      end

      def create
        application = Application.find_by(token: params[:application_token])

        REDIS.get("application_"+ application.id + "chat_counts")

        chat  = Chat.new(chat_params)
        chat.token = SecureRandom.uuid

        if chat.save
          render json: {data: chat.slice(@columns)},status: :ok
        else
          render json: {errors: chat.errors},status: :unprocessable_entity
        end
      end

      def index
        applications = Chat.all.select(@columns)
        render json: {data: applications}
      end

      def show
        chats = Chat.joins(:application).where(applications: { token: params[:application_token] })


        render json: {data: chats},status: :ok
      end

      def update
        chat = Chat.find_by(token: params[:token])

        if chat.update(chat_params)
          render json: {data: chat.slice(@columns)},status: :ok
        else
          render json: { errors: chat.errors }, status: :bad_request
        end
      end

      def destroy
        chat = Chat.find_by(token: params[:token])
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

      private
      def chat_params
          params.require(:chat).permit(:name)
      end
    end
  end
end
