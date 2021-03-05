class ImportPropertyService

  def initialize(params)
    @params = params
    @city_id = params[:city_id]
    @max_price = params[:max_price]
  end

  def call
    @params[:properties].each_with_index do |data, index|
      if index > 1
        property = Property.create(name: data[index][0],phone: data[index][1], specials: data[index][2], submarket: data[index][3], zip: data[index][4], built_year: data[index][5].to_i, escort: data[index][6].to_f * 100, management_company: data[index][19], web_link: data[index][20], google_map: data[index][21], manager_name: data[index][22], email: data[index][23], google_rating: data[index][24], lat: data[index][25].split.first.to_f, long: data[index][25].split.last.to_f, address: data[index][26])

        @params[:properties][0].each do |property_type|
          if property_type.include?(1)
            type = Type.find_by(type_code: 'bedroom_1')
          elsif property_type.include?(2)
            type = Type.find_by(type_code: 'bedroom_2')
          elsif property_type.include?(3)
            type = Type.find_by(type_code: 'bedroom_3')
          end
          property_type_detail = type.type_details.create(size: data[index][8], floor_plan: data[index][9], price: data[index][7], available: data[index][10])
          property_type_detail.update(property_id: property&.id)
          property_mapped = PropertyType.create(property_id: property&.id, type_id: type&.id)
        end
      end
    end
    OpenStruct.new(message: 'Properties Sucessfully Imported.', status: 200)
  end

end
