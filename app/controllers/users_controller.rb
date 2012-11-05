class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  def index
    @user = current_user
    render json: current_user
  end
end
