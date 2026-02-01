class LikesController < ApplicationController
  before_action :set_like, only: [ :destroy ]


  def create
    @like = current_user.likes.build(like_params)
    if @like.save
       redirect_back(fallback_location: root_path, notice: "Like the post successfully.")
    else
      redirect_back(fallback_location: root_path, alert: "Unable to like the post.")
    end
  end

  def destroy
    if @like.user_id == current_user.id
       @like.destroy
      redirect_back(fallback_location: root_path, notice: "Like has been removed.")
    else
      redirect_back(fallback_location: root_path, alert: "Unable to remove like.")
    end
  end

  private

  def like_params
    params.permit(:post_id)
  end

  def set_like
    @like = Like.find(params[:id])
  end
end
