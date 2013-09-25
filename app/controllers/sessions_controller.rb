class SessionsController < ApplicationController
  # include CustomSessions
  before_filter :require_logged_in, :only => [:destroy]
  
  def create
    @user = login(session[:session_id], params[:username], params[:password])
    
    if @user.nil?
      redirect_to login_path, :alert => 'We could not find an account corresponding to that username and password!'
    else
      session[:user_id] = @user.id
      session[:username] = @user.username
      
      if @user.is_admin?
        redirect_to users_path(session[:session_secret])
      else
        redirect_to user_path(session[:session_secret], @user)
      end
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to store_path, :notice => 'You were successfully logged out!'
  end
  
  def change_level
    change_session_id
    redirect_to :back
  end
  
  def reset_database
    # session[:session_id] = nil
    DB::reset(session[:session_id])
    reset_session
    redirect_to store_path, :notice => 'Database was reset!'
  end
end