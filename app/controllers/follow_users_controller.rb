class FollowUsersController < ApplicationController
  skip_before_action :is_admin?

  def create
    @user = User.find_by id: params[:follower]
    current_user.follow_users.create follower: @user.id
    @follow = current_user.follow_users.find_by follower: @user.id

    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
    
  end

  def destroy
    @follow = FollowUser.find_by id: params[:id]
    @user = User.find_by id: @follow.follower
    @follow.destroy
    @follow = current_user.follow_users.build

    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end
end
