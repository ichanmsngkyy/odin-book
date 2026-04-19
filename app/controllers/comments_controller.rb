class CommentsController < ApplicationController
  before_action :set_comment, only: [ :destroy ]

  def create
    @comment = current_user.comments.build(create_params)
    if @comment.save
      redirect_back(fallback_location: posts_path, notice: "Comment has been created ")
    else
      followed_user_ids = current_user.active_follows.where(status: :accepted).pluck(:followed_id)
      @posts = Post.where(user_id: followed_user_ids + [ current_user.id ]).order(created_at: :desc)
      @post = Post.new
      @failed_comment_post_id = @comment.post_id
      render "posts/index", status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.user_id == current_user.id
      @comment.destroy
      redirect_back(fallback_location: posts_path, notice: "Comment successfully deleted")
    else
      redirect_back(fallback_location: posts_path, alert: "Unable to delete comment")
    end
  end

  private

  def create_params
    params.permit(:content, :post_id, :photo)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
