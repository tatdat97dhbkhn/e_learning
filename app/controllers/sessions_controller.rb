class SessionsController < ApplicationController
  skip_before_action :is_admin?

  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      remember_forget user
      redirect_to root_url
    else
      flash.now[:danger] = t "errors1"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def remember_forget user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end
end
