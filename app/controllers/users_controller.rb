class UsersController < ApplicationController
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    # TODO: switch to CanCan to manage user abilities
    @user = User.find(params[:id])
    if current_user.admin? || @user.id == current_user.id
      # users can change these
      @user.name        = params[:user][:name]
      @user.email       = params[:user][:email]
      @user.password    = params[:user][:password] unless params[:user][:password].blank?
    end
    if current_user.admin?
      # admins can change these
      @user.admin    = params[:user][:admin]
      @user.approved = params[:user][:approved]
    end
    if @user.save # @user.update_attributes(params[:user]) doesn't work - mongoid bug?
      redirect_to(@user, :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(users_url, :notice => "Deleted user")
  end
end
