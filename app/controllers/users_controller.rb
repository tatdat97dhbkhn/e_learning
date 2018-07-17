class UsersController < ApplicationController
  def index
    @users = User.paginate page: params[:page], per_page: 20
  end

  def new
    @user = User.new
  end

  def show
    if current_user? current_user
      @user = current_user
      @lession_logs = @user.lession_logs.not_nill
      @lessions = Lession.get_name_by_lession_logs @lession_logs
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

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if user.update_attributes user_params_edit
      flash[:success] = t ".success"
      redirect_to user
    else
      render :edit
    end
  end

  private

  attr_reader :user

  def user_params
    params.required(:user).permit User::USER_ATTRS
  end

  def user_params_edit
    params.required(:user).permit User::USER_ATTRS_EDIT
  end
end
