class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    before_action :authenticate_user, only: [:show]
    
    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
      end

      def show
        user = User.find_by(id: session[:user_id])
        render json: user
      end

    private
    def user_params
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
      end
    
      def render_unprocessable_entity(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
      end

      def authenticate_user
        unless session[:user_id]
          render json: { error: "Not authenticated" }, status: :unauthorized
        end
      end
end
