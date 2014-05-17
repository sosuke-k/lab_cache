class SessionsController < ApplicationController
  def index

  end
  def create
    auth = request.env['omniauth.auth']
    user = User.find_by({twitter_id: auth.info.nickname}) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url, :notice => 'Signed in!'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Signed out!'
  end
end
