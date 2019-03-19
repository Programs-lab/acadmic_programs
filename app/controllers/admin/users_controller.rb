class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :destroy]
  def index
    @users = User.where("id NOT IN (?)", current_user.id)
    authorize @users
     # don't display the current user in the users list; go to account management to edit current user details
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path
    else
      render :action => 'new'
    end
    authorize @user
  end

  def edit
  end

  def update
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    if @user.update_attributes(params[:user])
      redirect_to users_path
    else
      render :action => 'edit'
    end
  end

  def delete
  end

  def destroy
    if @user.destroy
      redirect_to users_path
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :id_type,
      :id_number,
      :phone_number,
      :occupation,
      :birthdate,
      :address,
      :email
      )
  end

end
