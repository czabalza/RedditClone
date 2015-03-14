class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def login(user)
    user.reset_session_token!
    session[:token] = user.session_token
  end

  def logout(user)
    user.reset_session_token!
    session[:token] = nil
  end

  def current_user
    User.find_by_session_token(session[:token])
  end

  def logged_in?
    if current_user
      redirect_to user_url(current_user)
    end
  end

  def current_users_page?
    if current_user && current_user.id != params[:id].to_i
      redirect_to user_url(current_user)
    elsif !current_user
      redirect_to new_session_url
    end
  end

  def current_user_is_moderator?
    ssub = Sub.find(params[:id])
    unless current_user.id == ssub.moderator_id
      redirect_to subs_url
    end
  end

  def current_user_is_post_owner?
    post = Post.find(params[:id])
    unless current_user.id == post.author_id
      redirect_to post_url(post)
    end
  end

  def not_logged_in?
    redirect_to new_session_url if !current_user
  end
  
end
