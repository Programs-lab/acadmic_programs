# coding: utf-8
class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :destroy, :enable, :disable, :invite]
  def index
    if params[:query] &&  params[:query] != ""
      @users = User.where.not(id: current_user.id).search_by_personal_information(params[:query]).order(:last_name)
    else
      @users = User.where.not(id: current_user.id).order(:last_name)
    end
    
    #@users = User.where("id NOT IN (?)", current_user.id)
    authorize @users
    @pagy, @users = pagy(@users)
     # don't display the current user in the users list; go to account management to edit current user details
  end

  def doctors
    if params[:query] &&  params[:query] != ""
      @doctors = User.where(role: :doctor).search_by_personal_information(params[:query]).order(:last_name)
    else
      @doctors = User.where(role: :doctor).order(:last_name)
    end
    
    authorize @doctors
    @pagy, @doctors = pagy(@doctors)
  end

  def patients
    if params[:query] &&  params[:query] != ""
      @patients = User.where(role: :patient).search_by_personal_information(params[:query]).order(:last_name)
    else
      @patients = User.where(role: :patient).order(:last_name)
    end
    
    authorize @patients
    @pagy, @patients = pagy(@patients)
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    @user.skip_confirmation!
    path = admin_users_path
    if @user.save(context: :admin)
      @user.invite!      
      if user_params[:role] == 'doctor'
        path = admin_doctors_path
      elsif user_params[:role] == 'patient'
        path = admin_patients_path
      end
      redirect_to path, notice: 'El usuario fue creado exitosamente.'
    else
      redirect_to path, alert: 'No fue posible concretar el registro, por favor revise los campos nuevamente'
    end
  end

  def edit
  end

  def update
    authorize @user
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'El usuario fue actualizado exitosamente.'
    else
      redirect_to edit_admin_user_path(@user.id), alert: 'No fue posible concretar el registro, por favor revise los campos nuevamente'
    end
  end


  def invite
    authorize @user
    @user.invite!
    redirect_to edit_admin_user_path(@user.id), notice: "Se ha enviado una invitacion a #{@user.email} y expirará en 24 horas"
  end

  def delete
  end

  def destroy
    authorize @user
    if @user.destroy
      redirect_to admin_users_path, notice: 'El usuario fue eliminado correctamente.'
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
    params[:user][:procedure_type_ids] = params[:user][:procedure_type_ids].split(',') if params[:user][:procedure_type_ids].class == String
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
      :role,
      :company_id,
      procedure_type_ids: []
      )
  end

end
