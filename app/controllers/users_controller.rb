class UsersController < ApplicationController
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
    if current_user? current_user
      @user = current_user
      @lession_logs = @user.lession_logs.finished
      @lessions = Lession.get_name_by_lession_logs @lession_logs
      @results = LessionLog.get_result @lession_logs
    else
      redirect_to root_path
    end
  end

  def edit
    @user = current_user
  end

  def update
    if request.path == admin_path
      @user = current_user

      if user.update_attributes user_params_edit
        flash[:success] = t ".success"
        redirect_back fallback_location: root_path
      else
        flash[:danger] = t ".danger"
        render :edit
      end
    else
      @user = User.find_by id: params[:id]
      @user.update_attributes admin: !@user.admin
      redirect_back fallback_location: root_path
    end
  end

  def destroy
    @user = User.find_by id: params[:id]
    if user.destroy
      flash[:success] = t ".success"
      redirect_back fallback_location: root_path
    else
      flash[:success] = t ".danger"
      redirect_to root_path
    end
  end

  def admin
    @users = User.paginate page: params[:page],
      per_page: Settings.data.pages
    @master = User.find_by admin: true
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
