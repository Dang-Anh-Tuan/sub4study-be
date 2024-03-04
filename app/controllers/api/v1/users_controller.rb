require_relative '../../../dtos/user_dto'

class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  skip_before_action :authorized, only: [:create]
  
  def me
    p "@decode_payload #{@decode_payload}"
    
    result = current_user
    if result.is_a?(Hash) && result.key?(:message)
      render json: result, status: 401
    else 
      if result.key?(:user_id)
        @user = User.find_by(id: result[:user_id])
        if @user
          render json: UserDTO.new(@user), status: 200
        else
          render json: { message: "User not found" }, status: :not_found
        end
      else
        render json: { message: "User ID not provided in the result" }, status: :unprocessable_entity
      end
    end
  end
  
  def index
    @users = User.all
    render json: @users, status: 200
  end

  def show
    if @user
      render json: @user, status: 200
    else
      render json: "User not found"
    end
  end

  def create
    if params[:password] != params[:confirm_password]
      render json: {
        error: "Confirm password is not same password"
      }
    else 
      hashed_password = User.create_password_digest(params[:password])
      @user = User.new(
        name: params[:name],
        username: params[:username],
        password: hashed_password,
        email: params[:email],
        type_account: User::NORMAL,
        role: User::USER
      )
      if @user.save
        render json: { data: UserDTO.new(@user), status: 200 }
      else
        render json: { error: "Error creating user" }, status: :unprocessable_entity
      end
    end
   
  end

  def update
    if @user
      @user.update(users_params_update)
      render json: @user, status: 200
    else 
      render json: "User not found"
    end
  end

  def destroy
    if @user
      @user.destroy
      render json: "Delete success", status: 200
    else
      render json: "User not found"
    end
  end
  
  def get_all_folders
    @user = User.find_by(id: params[:user_id])  
    if @user
      folders = Folder.where(user: @user)
      render json: folders
    else
      render json: "User not found"
    end
  end
  
  def get_folders_by_path
  
  end
  
  private
  def set_user
    @user = User.find_by(id: params[:id])  
  end
  
  private
  def users_params
    params.require(:user).permit([
      :name,
      :username,
      :password,
      :email,
      :confirm_password
    ])
  end
  
  private
  def users_params_update
    params.require(:user).permit([
      :name,
      :username,
      :password,
      :email,
    ])
  end
end
