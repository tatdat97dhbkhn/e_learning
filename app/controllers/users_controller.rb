class UsersController < ApplicationController
  before_action :find_user, only: %i(show update destroy)
  before_action :logged_in_user, only: %i(index show edit update)
  skip_before_action :is_admin?, only: %i(index new create show edit update)

  def index
    @users = User.paginate page: params[:page],
      per_page: Settings.data.pages
  end

  def new
    @user = User.new
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

  def show
    @lession_logs = user.lession_logs.all.order_date
    @lessions = Lession.get_name_by_lession_logs @lession_logs
    @results = LessionLog.get_result @lession_logs
    @follow = current_user.follow_status user
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.equal? user
      update_profile user
      redirect_to profile_path
    else
      user.update_attributes admin: !user.admin
      redirect_back fallback_location: root_path
    end
  end

  def destroy
    if user.destroy
      flash[:success] = t ".success"
      redirect_back fallback_location: root_path
    else
      flash[:success] = t ".danger"
      redirect_to root_path
    end
  end

  def admin
    @users = User.all.page(params[:page]).per_page Settings.data.pages
    @master = User.find_by admin: true
  end

  private

  attr_reader :user

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    @user = current_user
  end

  def user_params
    params.required(:user).permit User::USER_ATTRS
  end

  def user_params_edit
    params.required(:user).permit User::USER_ATTRS_EDIT
  end

  def update_profile user
    if user.update_attributes user_params_edit
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".danger"
    end
  end
end
