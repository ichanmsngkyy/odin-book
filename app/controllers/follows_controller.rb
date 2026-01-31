class FollowsController < ApplicationController
    before_action :set_follo, only: [ :update, :destroy ]

    def create
        @follow = current_user.active_follows.build(follow_params)
        if @follow.save
            redirect_back(fallback_location: root_path, notice: "Follow request sent.")
        else
           redirect_back(fallback_location: root_path, alert: "Unable to send follow request.")
        end
    end

    def update
        @follow = Follow.find(params[:id])
        if @follow.followed_id == current_user.id
            @follow.update(status: :accepted) # accepted
            redirect_back(fallback_location: root_path, notice: "Follow request accepted.")
        else
            redirect_back(fallback_location: root_path, alert: "You are not authorized to accept this follow request.")
        end
    end


    def destroy
        @follow = Follow.find(params[:id])
        if @follow.follower_id == current_user.id || @follow.followed_id == current_user.id
            @follow.destroy
            redirect_back(fallback_location: root_path, notice: "Unfollowed successfully.")
        else
            redirect_back(fallback_location: root_path, alert: "You are not authorized to unfollow this user.")
        end
    end

    private

    def follow_params
       params.permit(:followed_id)
    end
end
