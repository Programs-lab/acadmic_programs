class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :destroy, :enable, :disable, :invite]
  def index
    @users = User.where.not(id: current_user.id, disabled: true)
    #@users = User.where("id NOT IN (?)", current_user.id)
    authorize @users
     # don't display the current user in the users list; go to account management to edit current user details
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    @user.skip_confirmation! 
    if @user.save(context: :admin)
      @user.invite!
      redirect_to admin_users_path, notice: 'El usuario fue creado exitosamente.'
    else
      redirect_to new_admin_user_path, alert: 'No fue posible concretar el registro, por favor revise los campos nuevamente'
    end
    authorize @user
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'El usuario fue actualizado exitosamente.'
    else
      redirect_to edit_admin_user_path(@user.id), alert: 'No fue posible concretar el registro, por favor revise los campos nuevamente'
    end
  end


  def invite
    @user.invite!
    redirect_to edit_admin_user_path(@user.id), notice: "Se ha enviado una invitacion a #{@user.email} y expirará en 24 horas"
  end

  def delete
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: 'El usuario eliminado correctamente.'
    end
  end

  def enable
    authorize @user
    respond_to do |format|
      if @user.update_attributes(disabled: false)
        format.html { redirect_to edit_admin_user_path(@user), notice: 'El usuario fue habilitado exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def disable
    authorize @user
    respond_to do |format|
      if @user.update_attributes(disabled: true)
        format.html { redirect_to edit_admin_user_path(@user), notice: 'El usuario fue deshabilitado exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

private

  def set_user
    @user = User.find(params[:id] || params[:user_id])
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
      :email,
      :role
      )
  end

end
