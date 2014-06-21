class SessionsController < ApplicationController

  def new
    render 'new'
  end

  def create
    auth_hash = request.env['omniauth.auth']

    if auth_hash.provider == 'github'
      uid = auth_hash.uid
      user = User.where(github_uid: uid).first
      user ||= User.new(github_uid: uid)
      user.public_email = auth_hash.info.email
      user.name = auth_hash.info.name
      user.nickname = auth_hash.info.nickname
      user.save!

      session[:user_id] = user.id
    else
      raise "Unrecognized omniauth provider: #{auth_hash['provider']}"
    end
    flash_message(:notice, "You have successfully signed in!")
    redirect_to root_path
  end

  def destroy
    session.delete :user_id
    redirect_to root_path
  end
end
