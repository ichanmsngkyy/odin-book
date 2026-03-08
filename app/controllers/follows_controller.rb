class FollowsController < ApplicationController
    before_action :set_follow, only: [ :update, :destroy ]

    def create
        @follow = current_user.active_follows.build(follow_params)
        @follow.status = :accepted
        if @follow.save
            @user = User.find(@follow.followed_id)
         respond_to do |format|
             format.turbo_stream
             format.html { redirect_back(fallback_location: root_path) }
           end
        else
            redirect_back(fallback_location: root_path, alert: "Unable to follow this user.")
        end
    end

    def update
        if @follow.followed_id == current_user.id
            @follow.update(status: :accepted) # accepted
            redirect_back(fallback_location: root_path, notice: "Follow request accepted.")
        else
            redirect_back(fallback_location: root_path, alert: "You are not authorized to accept this follow request.")
        end
    end


    def destroy
        if @follow.follower_id == current_user.id || @follow.followed_id == current_user.id
            @user = User.find(@follow.followed_id)
            @follow.destroy
            respond_to do |format|
             format.turbo_stream
             format.html { redirect_back(fallback_location:
             root_path) }
           end
        else
            redirect_back(fallback_location: root_path, alert: "You are not authorized to unfollow this user.")
        end
    end


    private

    def follow_params
        params.permit(:followed_id)
    end

    def set_follow
      @follow = Follow.find(params[:id])
    end
end
