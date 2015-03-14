class SessionsController < ApplicationController
  before_action :logged_in?, except: [:destroy] 

  def new
    @user = User.new
    render :new
  end

  def create

    @user = User.find_by_credentials(user_params[:name], user_params[:password])

    if @user
      login(@user)
      redirect_to user_url(@user)
    else
      @user = User.new
      flash.now[:errors] = ["Invalid Login"]
      render :new
    end
  end

  def destroy
    user = current_user
    logout(user)
    redirect_to new_session_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end
end
