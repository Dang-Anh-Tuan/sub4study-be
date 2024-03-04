class UserDTO
  attr_reader :id, :name, :type_account, :email, :Role
  
  def initialize(user)
    @id = user.id
    @name = user.name
    @type_account = user.type_account
    @email = user.email
    @role = user.type_account
  end
  
  def to_h
    { id: @id, name: @name, type_account: @type_account, email: @email, role: @role }
  end
end