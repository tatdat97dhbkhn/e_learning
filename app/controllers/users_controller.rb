class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    if current_user? current_user
      @user = current_user
    else
      redirect_to root_path
    end
  end

  def create
    @user = User.new user_params

    if user.save
      log_in user
      flash[:info] = t ".success"
      redirect_to root_path
    else
      render :new
    end
  end

  private

  attr_reader :user

  def user_params
    params.required(:user).permit User::USER_ATTRS
  end
end
