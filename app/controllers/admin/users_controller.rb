class Admin::UsersController < Admin::BaseController
  before_action :set_user, except: %i[index new create]

  def index
    # authorize [:admin, current_user]
    @users = User.order(:email)
  end

  def new
    @user = User.new
    # authorize [:admin, @user]
  end

  def create
    params = user_params.dup
    params[:password_confirmation] = params[:password]
    @user = User.new(params)

    # authorize [:admin, current_user]

    if @user.save
      flash[:notice] = 'User has been created'
      redirect_to admin_users_path
    else
      flash[:alert] = 'User has not been created'
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    params = user_params.dup
    params[:password_confirmation] = params[:password]

    if @user.update(params)
      flash[:notice] = 'User has been updated'
      redirect_to admin_users_path
    else
      flash[:alert] = 'User has not been updated'
      render 'edit'
    end
  end

  def destroy
    if @user == current_user
      flash[:alert] = 'You cannot delete yourself!'
    else
      @user.destroy
      flash[:notice] = 'User has been deleted'
    end
    redirect_to admin_users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
end
