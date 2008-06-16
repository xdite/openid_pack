class OpenidsController < ApplicationController

  before_filter :login_required
  skip_before_filter :verify_authenticity_token

  def new
    user_openid = UserOpenid.new
  end

  def create
    open_id_authentication(params[:openid_url])
  end

  def destroy
  
    user_openid = current_user.openids.find(params[:id])

    if current_user.openids.count > 1
      if user_openid.destroy
        flash[:notice] = "OpenID deleted" 
      else
        flash[:error] = "OpenID delete failed."
      end
    else
        flash[:notice] = "You only have 1 Openid"
    end
      respond_to do |format|                                                        format.html { redirect_to edit_user_url(current_user) }
      end   

  end

  protected

  def open_id_authentication(openid_url)
    authenticate_with_open_id(openid_url, :required => [:nickname, :email]) do |result, identity_url, registration|
      if result.successful?
        identity_url = identity_url.gsub(%r{/$},'')
        current_user_openid = UserOpenid.new(:user_id => current_user.id, :openid_url => identity_url )
        respond_to do |format|
          format.html{
            if current_user_openid.save
              redirect_to edit_user_url(current_user)
            else
              render :action => "new"
            end
          }
        end
      else
        render :action => "new"
      end
    end
  end

end
