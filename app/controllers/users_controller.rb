class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t "success"
      redirect_to @user
    else
      flash[:danger] = t "danger"
      render :new
    end
  end

  def show
    return if (@user = User.find_by id: params[:id])
    flash[:danger] = t "danger"
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
