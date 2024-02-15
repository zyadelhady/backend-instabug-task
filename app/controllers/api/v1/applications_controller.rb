module Api
  module V1
    class ApplicationsController < ApplicationController
      def initialize
        @columns = Application.attribute_names - ['id']
      end

      def create
        application  = Application.new(application_params)
        application.token = SecureRandom.uuid

        if application.save
          render json: {data: application.slice(@columns)},status: :ok
          REDIS.incr("application_"+ application.id + "chat_counts")
        else
          render json: {errors: application.errors},status: :unprocessable_entity
        end
      end

      def index
        applications = Application.all.select(@columns)
        render json: {data: applications}
      end

      def show
        application = Application.find_by(token: params[:token])

        if application
          render json: {data: application.slice(@columns)},status: :ok
        else
          render json: { errors: 'Application not found' }, status: :not_found
        end
      end

      def update
        application = Application.find_by(token: params[:token])

        if application.update(application_params)
          render json: {data: application.slice(@columns)},status: :ok
        else
          render json: { errors: application.errors }, status: :bad_request
        end
      end

      def destroy
        application = Application.find_by(token: params[:token])
        if application
          if application.destroy
            render :no_content
          else
          render json: {errors: application.errors},status: :unprocessable_entity
          end
        else
          render json: {errors: "Application not found"},status: :not_found
        end
      end

      private
      def application_params
          params.require(:application).permit(:name)
      end
    end
  end
end
