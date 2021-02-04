user = User.find_or_create_by(email: 'admin@yopmail.com')
if user
  user.update_attributes(password: "12345678", is_admin: true)
end
