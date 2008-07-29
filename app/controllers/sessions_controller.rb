# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead

  # render new.rhtml
  def new
  end

  def create
    if using_open_id?
      open_id_authentication(params[:openid_url])
    else
      password_authentication(params[:login], params[:password])
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected

  def open_id_authentication(openid_url)
    authenticate_with_open_id(openid_url, :required => [:nickname, :email]) do |result, identity_url, registration|
      if result.successful?
        identity_url = identity_url.gsub(%r{/$},'')
        @user_openid = UserOpenid.find_by_openid_url(identity_url)
        if @user_openid
          self.current_user = @user_openid.user
          successful_login
        else
          @user = User.find_or_initialize_by_identity_url(identity_url)
          if @user.new_record?
            @user.login = registration['nickname']
            @user.email = registration['email']
            @user.identity_url = identity_url
            complete_fillup
          else
            self.current_user = @user
            successful_login
          end
        end
      else
        failed_login result.message
      end
    end
  end

  def password_authentication(login, password)
    self.current_user = User.authenticate(login, password)
    (logged_in?) ? successful_login : failed_login
  end

  def complete_fillup
    render :template => "users/fillup"
  end

  def successful_login
    if params[:remember_me] == "1"
      self.current_user.remember_me
      cookies[:auth_token] = { :value => self.current_user.remember_token , :expires =>self.current_user.remember_token_expires_at }
    end
    redirect_back_or_default('/')
  end

  def failed_login(message = "Authentication failed.")
    flash[:error] = message
    redirect_to login_path
  end
end
