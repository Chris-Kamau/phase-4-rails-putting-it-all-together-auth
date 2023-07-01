class RecipesController < ApplicationController
    before_action :authenticate_user, only: [:create]
    
    def index
      recipes = Recipe.all
      render json: recipes, include: { user: { only: [:username, :image_url, :bio] } }, only: [:id, :title, :instructions, :minutes_to_complete], status: :ok
    end
  
    def create
      recipe = Recipe.new(recipe_params)
  
      if recipe.save
        render json: recipe, include: { user: { only: [:username, :image_url, :bio] } }, only: [:title, :instructions, :minutes_to_complete], status: :created
      else
        render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def recipe_params
      params.permit(:title, :instructions, :minutes_to_complete).merge(user_id: session[:user_id])
    end
  
    def authenticate_user
      unless session[:user_id]
        render json: { error: "Not authenticated" }, status: :unauthorized
      end
    end
  end
  