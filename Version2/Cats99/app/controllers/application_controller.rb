class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :login_user!, :reset_session_token!

  def current_user
    current_session = Session.find_by(session_token: session[:session_token])
    User.find(current_session.user_id) if current_session
  end

  def login_user!
    @user = User.find_by_credentials(params[:user][:user_name],
         params[:user][:password]
    )
    if @user
      session[:session_token] = reset_session_token!(@user)
      redirect_to user_url
    else
      @user = User.new
      flash.now[:errors] = "Not a valid username/password combinatioin"
      render :new
    end
  end

  def user_agent
    request.env["HTTP_USER_AGENT"]
  end

  def reset_session_token!(user)

    sesh = Session.find_by(session_token: session[:session_token])
    new_token = SecureRandom::urlsafe_base64(16)
    if sesh
      sesh.update(session_token: new_token)
    else
      Session.create(user_id: user.id,
                     user_agent: user_agent,
                     session_token: new_token
                     )
    end
    new_token
  end

end
