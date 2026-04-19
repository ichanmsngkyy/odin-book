class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_suggested_users
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def set_suggested_users
    @suggested_users = []
    return unless user_signed_in?

    followed_or_requested_ids = current_user.active_follows.select(:followed_id)

    @suggested_users = User
      .where.not(id: current_user.id)
      .where.not(id: followed_or_requested_ids)
      .limit(8)
  end
end
