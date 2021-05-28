class FilterPropertyService

  def initialize(params, properties)
    @params = params
    @properties = properties
    @max_price = params[:max_price] == "" ? TypeDetail.maximum(:price) : params[:max_price].to_i
    @sq_feet = params[:sq_ft] == "" ? 0 : params[:sq_ft].to_i
    @commission = params[:commission] == "" ? 0 : params[:commission].to_i
    @send_commisson = params[:send_commison] == "" ? 0 : params[:send_commison].to_i
    @bedroom_type = params[:show_property_type]
    @zip = params[:new_filter][:zip] == "" ? properties.pluck(:zip) : params[:new_filter][:zip]
  end

  def call
    if @params[:yearFilter][:to_year].present? && @params[:yearFilter][:from_year].present? && @params[:sq_ft] != ""
      properties = @properties.price_filter(@max_price).bedroom_filter(@params[:show_property_type]).sq_feet_filter(@sq_feet).built_year_filter(@params[:yearFilter][:from_year].to_i, @params[:yearFilter][:to_year].to_i).escort_filter(@commission).send_escort_filter(@send_commisson).search_filter(@params[:search]).zip_filter(@zip).order(created_at: :asc)
    elsif @params[:yearFilter][:to_year].present? && @params[:yearFilter][:from_year].present? && @params[:sq_ft] == ""
      properties = @properties.bedroom_filter(@params[:show_property_type]).price_filter( @max_price).built_year_filter(@params[:yearFilter][:from_year].to_i, @params[:yearFilter][:to_year].to_i).zip_filter(@zip).escort_filter(@commission).send_escort_filter(@send_commisson).search_filter(@params[:search]).order(created_at: :asc)
    elsif @params[:sq_ft] != ""
      properties = @properties.bedroom_filter(@params[:show_property_type]).price_filter(@max_price).sq_feet_filter(@sq_feet).escort_filter(@commission).zip_filter(@zip).send_escort_filter(@send_commisson).search_filter(@params[:search]).order(created_at: :asc)
    else
      properties = @properties.bedroom_filter(@params[:show_property_type]).price_filter(@max_price).escort_filter(@commission).send_escort_filter(@send_commisson).zip_filter(@zip).search_filter(@params[:search]).order(created_at: :asc)
    end

    OpenStruct.new(message: 'Properties.', status: 200, properties: ActiveModelSerializers::SerializableResource.new(properties.uniq, each_serializer: PropertySerializer))

  end

end
