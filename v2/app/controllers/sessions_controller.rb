class SessionsController < ApplicationController
  before_action :already_signed_in, only: [:new, :create]
  def create
    login_user!
  end

  def destroy
    session_id = Session.find_by(session_token: session[:session_token]).id
    Session.destroy(session_id)
    session[:session_token] = nil
    @user = User.new
    render :new
  end

  def new
    @user = User.new
    render :new
  end

  private

  def already_signed_in
    if current_user
      redirect_to cats_url
    end
  end

end
