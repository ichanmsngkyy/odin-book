class UsersController < ApplicationController
  def index
    @users = User.where.not(id: current_user.id)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end

  def follow_requests
    @pending_follows = current_user.passive_follows.where(status: :pending)
  end
end
