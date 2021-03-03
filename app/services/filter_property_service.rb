class FilterPropertyService

  def initialize(params)
    @params = params
  end

  def call
    if @params[:city_id].present?
      city = City.find_by(id: @params[:city_id])&.name
      if city == "All"
        if @params[:yearFilter][:to_year].present? && @params[:yearFilter][:from_year].present? && !@params[:commission].present?
          properties = Property.all.price_filter(0, @params[:max_price]).built_year_filter(@params[:yearFilter][:from_year].to_i, @params[:yearFilter][:to_year].to_i).order(created_at: :asc)
        elsif @params[:commission].present? && !@params[:yearFilter][:to_year].present? && !@params[:yearFilter][:from_year].present?
          properties = Property.all.price_filter(0, @params[:max_price]).escort_filter(@params[:commission].to_i).order(created_at: :asc)
        elsif @params[:yearFilter][:to_year].present? && @params[:yearFilter][:from_year].present? && @params[:commission].present?
          properties = Property.all.price_filter(0, @params[:max_price]).built_year_filter(@params[:yearFilter][:from_year].to_i, @params[:yearFilter][:to_year].to_i).escort_filter(@params[:commission].to_i).order(created_at: :asc)
        else
          properties = Property.all.price_filter(0, @params[:max_price]).order(created_at: :asc)
        end
      else
        if @params[:yearFilter][:to_year].present? && @params[:yearFilter][:from_year].present? && !@params[:commission].present?
          properties = Property.where(city_id: @params[:city_id].to_i).price_filter(0, @params[:max_price]).built_year_filter(@params[:yearFilter][:from_year].to_i, @params[:yearFilter][:to_year].to_i).order(created_at: :asc)
        elsif @params[:commission].present? && !@params[:yearFilter][:to_year].present? && !@params[:yearFilter][:from_year].present?
          properties = Property.where(city_id: @params[:city_id].to_i).price_filter(0, @params[:max_price]).escort_filter(@params[:commission].to_i).order(created_at: :asc)
        elsif @params[:yearFilter][:to_year].present? && @params[:yearFilter][:from_year].present? && @params[:commission].present?
          properties = Property.where(city_id: @params[:city_id].to_i).price_filter(0, @params[:max_price]).built_year_filter(@params[:yearFilter][:from_year].to_i, @params[:yearFilter][:to_year].to_i).escort_filter(@params[:commission].to_i).order(created_at: :asc)
        else
          properties = Property.where(city_id: @params[:city_id].to_i).price_filter(0, @params[:max_price]).order(created_at: :asc)
        end
      end
      OpenStruct.new(message: 'Properties.', status: 200, properties: ActiveModelSerializers::SerializableResource.new(properties, each_serializer: PropertySerializer))
    else
      OpenStruct.new(message: 'City not found.', status: 402, properties: [])
    end
  end


end
