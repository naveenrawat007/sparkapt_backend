class FilterPropertyService

  def initialize(params, properties)
    @params = params
    @properties = properties
    @max_price = params[:new_filter][:max_price] == "" ? TypeDetail.maximum(:price) : params[:new_filter][:max_price].to_i
    @min_price = params[:new_filter][:min_price] == "" ? TypeDetail.minimum(:price) : params[:new_filter][:min_price].to_i

    @available_from = params[:avail_from] ? params[:avail_from].to_date + 1.day : TypeDetail.minimum(:move_in)
    @available_to = params[:avail_to] ? params[:avail_to].to_date + 1.day : TypeDetail.maximum(:move_in)

    @from_year = @params[:yearFilter][:from_year] == "" ? Property.minimum(:built_year) : @params[:yearFilter][:from_year].to_i
    @to_year = @params[:yearFilter][:to_year] == "" ? Property.maximum(:built_year) : @params[:yearFilter][:to_year].to_i

    @sq_feet = params[:sq_ft] == "" ? 0 : params[:sq_ft].to_i
    @commission = params[:commission] == "" ? 0 : params[:commission].to_i
    @send_commisson = params[:send_commison] == "" ? 0 : params[:send_commison].to_i
    @bedroom_type = params[:show_property_type]
    @zip = params[:new_filter][:zip] == "" ? properties.pluck(:zip).uniq : params[:new_filter][:zip]
    @market = params[:selMarket] == [] ? properties.pluck(:submarket).uniq : params[:selMarket]&.map{ |market| market.values }&.flatten&.uniq
  end

  def call
    if @params[:sq_ft] != ""
      properties = @properties.bedroom_filter(@params[:show_property_type]).year_from_filter(@from_year).year_to_filter(@to_year).min_price_filter(@min_price).max_price_filter(@max_price).sq_feet_filter(@sq_feet).market_filter(@market).escort_filter(@commission).avail_from_filter(@available_from).avail_to_filter(@available_to).zip_filter(@zip).send_escort_filter(@send_commisson).search_filter(@params[:search]).order(created_at: :asc)
    else
      properties = @properties.bedroom_filter(@params[:show_property_type]).year_from_filter(@from_year).year_to_filter(@to_year).min_price_filter(@min_price).avail_from_filter(@available_from).avail_to_filter(@available_to).max_price_filter(@max_price).escort_filter(@commission).market_filter(@market).send_escort_filter(@send_commisson).zip_filter(@zip).search_filter(@params[:search]).order(created_at: :asc)
    end

    OpenStruct.new(message: 'Properties.', status: 200, properties: ActiveModelSerializers::SerializableResource.new(properties.uniq, each_serializer: PropertySerializer))

  end

end
