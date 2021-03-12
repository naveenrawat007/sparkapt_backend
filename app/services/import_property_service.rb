class ImportPropertyService

  def initialize(params)
    @params = params
    @city_id = params[:city_id].to_i
    @max_price = params[:max_price]
  end

  def call
    @params[:properties].each_with_index do |data, index|

      if index > 1
        if data[0].present?
          property = Property.create(name: data[0].to_s,phone: data[1].to_s, specials: data[2].to_s, submarket: data[3].to_s, zip: data[4].to_s, built_year: data[5].to_i, escort: data[6].to_f * 100, management_company: data[19].to_s, web_link: data[20].to_s, google_map: data[21].to_s, manager_name: data[22].to_s, email: data[23].to_s, google_rating: data[24].to_s, lat: data[25].to_s.split.first.to_f, long: data[25].to_s.split.last.to_f, address: data[26].to_s, city_id: @city_id)

          @params[:properties][0].each do |property_type|
            if property_type.include?("1")
              type = Type.find_by(type_code: 'bedroom_1')
              property_type_detail = type.type_details.create(size: data[8].to_f, floor_plan: data[9].to_s, price: data[7].to_f, available: data[10].to_s)
            elsif property_type.include?("2")
              type = Type.find_by(type_code: 'bedroom_2')
              property_type_detail = type.type_details.create(size: data[12].to_f, floor_plan: data[13].to_s, price: data[11].to_f, available: data[14].to_s)
            elsif property_type.include?("3")
              type = Type.find_by(type_code: 'bedroom_3')
              property_type_detail = type.type_details.create(size: data[16].to_f, floor_plan: data[17].to_s, price: data[15].to_f, available: data[18].to_s)
            end
            property_type_detail.update(property_id: property&.id)
            property_mapped = PropertyType.create(property_id: property&.id, type_id: type&.id)
          end
        end

      end
    end
    OpenStruct.new(message: 'Properties Sucessfully Imported.', status: 200)
  end

end
