require 'jwt'
require_relative '../../../jwt/jwt_helper.rb'

class Api::V1::AuthController < ApplicationController
  skip_before_action :authorized, only: [:login, :refresh_token]
  
  DURATION_TIME_JWT = 300 # (5 minutes)
  DURATION_TIME_REFRESH_JWT = 2592000 # (1 month)
  
  def self.generate_response_token (user)
    time_now = Time.now.to_i
    exp = time_now + DURATION_TIME_JWT
    exp_refresh = time_now + DURATION_TIME_REFRESH_JWT
    
    # Create token
    @token = JWTHelper.create_token(user, time_now, exp)
    # Create refresh token 
    @refresh_token = JWTHelper.create_token(user, time_now, exp_refresh)
    user.update(refresh_token: @refresh_token)
    return {
      access_token: @token,  
      refresh_token: @refresh_token,
      iat: time_now,
      exp: exp,
      exp_refresh: exp_refresh
    }.transform_keys(&:to_s)
  end
  
  def login
    @user = User.find_by(username: login_params[:username])
    if @user
      if @user.authenticate(login_params[:password], @user.password)
        result = self.class.generate_response_token(@user)
        render json: {data: result, status: 200}, status: 200
      else
        render json: { error: 'Invalid username or password' }, status: :unauthorized
      end
    else 
      render json: { error: 'Not found user' }, status: 404
    end
  end
  
  def refresh_token
    decode_payload = JWT.decode(refresh_params[:refresh_token], 
      ENV["SECRET_KEY_JWT"], 
      true, 
      algorithm: 'HS256'
    )
    payload = decode_payload[0]
    exp = payload['exp']
    time_now = Time.now.to_i
    if exp < time_now
      render json: { message: "Refresh token is expired" }, status: 401
    else 
      user_id = payload['id']
      user = User.find_by(id: user_id)
      if user.refresh_token == refresh_params[:refresh_token]
        render json: {data: self.class.generate_response_token(user), status: 200}, status: 200
      else
        render json: { message: "Refresh token invalid" }, status: 401
      end
    end
  end
  
  def refresh_params 
    params.permit(:refresh_token)
  end
  
  def login_params 
    params.permit(:username, :password)
  end
end
