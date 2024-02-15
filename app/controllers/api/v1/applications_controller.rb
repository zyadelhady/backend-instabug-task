module Api
  module V1
    class ApplicationsController < ApplicationController
      def create
        application  = Application.new(application_params)
        application.token = SecureRandom.uuid

        if application.save
          render json: application.as_json(only: [:name,:token,:created_at])
        else
          render json: {errors: application.errors},status: :unprocessable_entity
        end
      end
      def index
        applications = Application.all
        render json: applications.as_json(only: [:name, :token, :created_at])
      end

      def show
        application = Application.find_by(token: params[:token])

        if application
          render json: application.as_json(only: [:name, :token, :created_at])
        else
          render json: { errors: 'Application not found' }, status: :not_found
        end
      end

      def update
        application = Application.find_by(token: params[:token])

        if application.update(application_params)
          render json: application.as_json(only: [:name, :token, :created_at])
        else
          render json: { data: application.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        application = Application.find_by(token: params[:token])
        if application
          if application.destroy
            render json: "deleted Sucessfuly"
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
