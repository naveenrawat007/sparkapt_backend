class ImportPropertyService

  def initialize(params)
    @params = params
    @city_id = params[:city_id].to_i
    @max_price = params[:max_price]
  end

  def call
    @params[:properties].each_with_index do |data, index|
      if index > 1

        if data[0].present? && !Property.find_by(name: data[0].to_s).present?
          property = Property.create(name: data[0].to_s,phone: data[1].to_s, specials: data[2].to_s, submarket: data[3].to_s, zip: data[4].to_s, built_year: data[5].to_i, send_escort: data[6].to_f * 100, escort: data[7].to_f * 100, management_company: data[20].to_s, web_link: data[21].to_s, google_map: data[22].to_s, manager_name: data[23].to_s, email: data[24].to_s, google_rating: data[25].to_s, lat: data[26].to_s.split.first.to_f, long: data[26].to_s.split.last.to_f, address: data[27].to_s, city_id: @city_id, floor_plan_link: data[28].to_s, photo_gallery_link: data[29].to_s, google_review_link: data[30].to_s)

          @params[:properties][0].slice(1,5).each do |property_type|
            if property_type.include?("1")
              type = Type.find_by(type_code: 'bedroom_1')
              property_type_detail = type.type_details.create(size: data[12].to_f, price: data[11].to_s.gsub(/[^0-9A-Za-z]/, '').to_f, available: data[13].to_s, property_type_name: type.name)
            elsif property_type.include?("2")
              type = Type.find_by(type_code: 'bedroom_2')
                property_type_detail = type.type_details.create(size: data[15].to_f, price: data[14].to_s.gsub(/[^0-9A-Za-z]/, '').to_f, available: data[16].to_s, property_type_name: type.name)
            elsif property_type.include?("3")
              type = Type.find_by(type_code: 'bedroom_3')
              property_type_detail = type.type_details.create(size: data[18].to_f, price: data[17].to_s.gsub(/[^0-9A-Za-z]/, '').to_f, available: data[19].to_s, property_type_name: type.name)
            elsif property_type.include?("Studio")
              type = Type.find_by(type_code: 'studio')
              property_type_detail = type.type_details.create(size: data[9].to_f, price: data[8].to_s.gsub(/[^0-9A-Za-z]/, '').to_f, available: data[10].to_s, property_type_name: type.name)
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
