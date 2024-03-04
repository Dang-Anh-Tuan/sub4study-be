class User < ApplicationRecord
  # Role
  ADMIN = 1
  USER = 2
  
  # Type account
  NORMAL = 1
  GOOGLE = 2
  
  def self.create_password_digest(password)
    BCrypt::Password.create(password)
  end
  
  def authenticate (password_input, password)
    stored_password = BCrypt::Password.new(password)
    stored_password == password_input
  end
end
