class PostsController < ApplicationController
  before_action :set_post, only: [ :destroy, :retweet ]


  def index
    load_feed_posts
    @post = Post.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(create_params)
    if @post.save
      redirect_to(fallback_location: posts_path, notice: "Post has been created.")
    else
      load_feed_posts
      @failed_comment_post_id = nil
      render :index, status: :unprocessable_entity
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

  def retweet
    target_post = @post.original_post || @post
    existing_retweet = current_user.posts.find_by(original_post: target_post)

    if existing_retweet
      existing_retweet.destroy
      redirect_back(fallback_location: posts_path, notice: "Retweet removed.")
      return
    end

    retweet = current_user.posts.build(original_post: target_post)
    if retweet.save
      redirect_back(fallback_location: posts_path, notice: "Retweeted.")
    else
      redirect_back(fallback_location: posts_path, alert: retweet.errors.full_messages.to_sentence.presence || "Unable to retweet.")
    end
  rescue ActiveRecord::RecordNotUnique
    redirect_back(fallback_location: posts_path, alert: "You already retweeted this post.")
  end

  private

  def create_params
    params.permit(:content, photos: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def load_feed_posts
    followed_user_ids = current_user.active_follows.where(status: :accepted).pluck(:followed_id)
    @posts = Post.includes(:user, :likes, :comments, :original_post, original_post: [ :user, :likes, :comments ])
                 .where(user_id: followed_user_ids + [ current_user.id ])
                 .order(created_at: :desc)
  end
end
