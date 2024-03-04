require 'jwt'
require_relative '../dtos/user_dto.rb'

class JWTHelper
  def self.encode_token(payload)
    JWT.encode(payload, ENV["SECRET_KEY_JWT"])
  end
  
  def self.create_token(user, time_now, exp)
    return JWTHelper.encode_token({
      **UserDTO.new(user).to_h,
      iat: time_now,
      exp: exp
    })
  end
end
