class UsersController < ApplicationController
  def index
    @users = @suggested_users
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end

  def follow_requests
    @pending_follows = current_user.passive_follows.includes(:follower).where(status: :pending)
  end
end
