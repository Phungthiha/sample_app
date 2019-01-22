class UsersController < ApplicationController
  before_action :load_user, except: %i(index new create)
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.page(params[:page]).per Settings.pages_limit
  end

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

  def show; end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      flash[:danger] = t "noww"
      render :edit
    end
  end

  def destroy
    flash[:success] = t "user_deleted"
    redirect_to user_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "please_log_in"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user.current_user? @user
  end

  def load_user
    @user = User.find_by id: params[:id]

    return if @user.present?
    flash[:danger] = t "danger"
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
