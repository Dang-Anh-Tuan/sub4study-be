require_relative "../jwt/jwt_helper.rb"

class ApplicationController < ActionController::API
  before_action :authorized
  
  def decode_token
    @decoded_token ||= begin
      header = request.headers['Authorization']
      if header 
        @current_token = header.split(" ")[1]
        begin
          JWT.decode(@current_token, ENV["SECRET_KEY_JWT"], true, algorithm: 'HS256')
        rescue JWT::DecodeError
          nil
        end
      end
    end
  end
  
  def current_user
    if decode_token
      @decode_payload = decode_token[0]
      exp = @decode_payload['exp']
      time_now = Time.now.to_i
      if exp < time_now
        return { message: "Token is expired" }
      else 
        user_id = @decode_payload['id']
        return { user_id: user_id }
      end
    else 
      return { message: "login error" }
    end
  end
  
  def authorized
    current_user_res = current_user
    unless current_user_res.is_a?(Hash) && current_user_res.key?(:user_id)
    render json: { message: 'Please log in' }, status: :unauthorized
    end
  end
end
