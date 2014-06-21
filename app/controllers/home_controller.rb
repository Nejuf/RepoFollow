class HomeController < ApplicationController
  before_filter :authenticate_user

  def index
    render 'index'
  end

  def authenticate_user
    redirect_to sign_up_path unless current_user
  end
end
