# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)\
Folder.destroy_all
User.destroy_all

user1 = User.create(id: 1, name: "Tuan", username: "admin", password: User.create_password_digest("123456"), email: "tuanda2@vmogroup.com", type_account: 1, role: 1)
user2 = User.create(id: 2, name: "Kien", username: "username1", password: User.create_password_digest("123456"), email: "userkien@gmail.com", type_account: 1, role: 2)
user3 = User.create(id: 3, name: "Trong", username: "username2", password: User.create_password_digest("123456"), email: "usertrong@gmail.com", type_account: 1, role: 2)

Folder.create(id: 1, name: "Tai lieu mat", path: "", user: user1)
Folder.create(id: 2, name: "Tai lieu lap trinh", path: "Tai lieu mat", user: user1)
Folder.create(id: 3, name: "Tieng Anh giao tiep", path: "Tai lieu mat/Tai lieu lap trinh", user: user1)
Folder.create(id: 4, name: "Toeic", path: "Tai lieu mat", user: user1)
Folder.create(id: 5, name: "Tactics listening", path: "", user: user2)
