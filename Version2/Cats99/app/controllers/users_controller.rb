class UsersController < ApplicationController
  before_action :already_signed_in, only: [:new]
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:session_token] = @user.session_token
      login_user!
    else
      render :new
    end
  end

  def show # Showing your cat rentals
    @user = current_user
    @cat_rental_requests = @user.cat_rental_requests
    @logged_in_useragents = []
    Session.where(user_id: @user.id).each do |sesh|
      @logged_in_useragents << sesh.user_agent
    end
    render :show
    #redirect_to cats_url
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
  def already_signed_in
    if current_user
      redirect_to cats_url
    end
  end

end