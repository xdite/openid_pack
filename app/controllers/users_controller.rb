class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead

  before_filter :login_required, :only => [:edit, :update]

  # render new.rhtml
  def new
    @user = User.new
  end

  def edit                                                                  
    @user = User.find(current_user.id)                                      
    @user_openids = @user.openids
  end

  def update
    @user = current_user
    @user_openids = @user.openids
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html {redirect_to :action => "edit"}
      else
        format.html { render :action => "edit" } 
      end
    end
  end

  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    if @user.save                                                           
      self.current_user = @user                                             
      redirect_back_or_default('/')                                         
    elsif @user.identity_url                                                
      render :action => 'fillup'                                            
    else                                                                    
      render :action => 'new'                                               
    end 
  end
end
