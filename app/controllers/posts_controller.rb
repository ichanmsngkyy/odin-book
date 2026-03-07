class PostsController < ApplicationController
  before_action :set_post, only: [ :destroy ]

  def index
    followed_user_ids = current_user.active_follows.where(status: :accepted).pluck(:followed_id)
    @posts = Post.all.where(user_id: followed_user_ids + [ current_user.id ]).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(create_params)
    if @post.save
      redirect_to(fallback_location: posts_path, notice: "Post has been created.")
    else
      redirect_back(fallback_location: posts_path, alert: "Unable to create post.")
    end
  end

  def destroy
    if @post.user_id == current_user.id
      @post.destroy
      redirect_back(fallback_location: posts_path, notice: "Post has been deleted.")
    else
      redirect_back(fallback_location: posts_path, alert: "Unable to delete post.")
    end
  end

  private

  def create_params
    params.permit(:content)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
