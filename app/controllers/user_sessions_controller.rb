class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_to(:users, success: "Login successful")
    else
      flash.now[:error] = "Login Failed"
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(:login, success: "Logged out")
  end
end
