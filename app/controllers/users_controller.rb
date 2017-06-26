class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :verify_admin, only: :destroy
  before_action :load_user, except: [:index, :new, :create]

  def index
    @users = User.select(:id, :name, :email, :created_at).order(created_at: :asc)
      .paginate page: params[:page], per_page: Settings.user.users_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".please_check_your_email"
      redirect_to root_url
    else
      flash.now[:danger] = t ".no_created"
      render :new
    end
  end

  def show
    @microposts = @user.microposts.paginate page: params[:page],
      per_page: Settings.user.users_per_page
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".you_can_not_delete"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".please_log_in"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]

    return if @user.is_user? current_user
    redirect_to root_url
    flash[:danger] = t ".you_have_not_access"
  end

  def verify_admin
    redirect_to root_url unless current_user.is_admin?
  end

  def load_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t(".note") << params[:id]
    redirect_to signup_path
  end
end
