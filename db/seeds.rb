user = User.find_or_create_by(email: 'admin@yopmail.com')
if user
  user.update_attributes(password: "12345678", is_admin: true)
end
Type.find_or_create_by(name:'1 Bedroom', type_code: 'bedroom_1')
Type.find_or_create_by(name:'2 Bedroom', type_code: 'bedroom_2')
Type.find_or_create_by(name:'3 Bedroom', type_code: 'bedroom_3')
Type.find_or_create_by(name:'Studio', type_code: 'studio')
