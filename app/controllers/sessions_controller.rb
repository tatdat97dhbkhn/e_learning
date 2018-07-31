class SessionsController < ApplicationController
  skip_before_action :is_admin?

  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      active? user
    else
      flash.now[:danger] = t "errors1"
      render :new
    end
  end

  def create_google
    @user = User.find_or_create_from_auth_hash request.
      env["omniauth.auth"]
    session[:user_id] = @user.id
    redirect_to root_url
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def remember_forget user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end

  def active? user
    if user.activated?
      log_in user
      remember_forget user
      redirect_back_or user
    else
      flash[:warning] = t ".message"
      redirect_to root_url
    end
  end
end
