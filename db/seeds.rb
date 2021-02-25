user = User.find_or_create_by(email: 'admin@yopmail.com')
if user
  user.update_attributes(password: "12345678", is_admin: true)
end
Type.find_or_create_by(name:'1 Bedroom')
Type.find_or_create_by(name:'2 Bedroom')
Type.find_or_create_by(name:'3 Bedroom')
Type.find_or_create_by(name:'Studio')
