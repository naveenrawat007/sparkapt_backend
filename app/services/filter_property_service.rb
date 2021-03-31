class FilterPropertyService

  def initialize(params, properties)
    @params = params
    @properties = properties
    @sq_feet = params[:sq_ft] == "" ? 0 : params[:sq_ft].to_i
    @commission = params[:commission] == "" ? 0 : params[:commission].to_i
    @send_commisson = params[:send_commison] == "" ? 0 : params[:send_commison].to_i
  end

  def call
    if @params[:yearFilter][:to_year].present? && @params[:yearFilter][:from_year].present?
      properties = @properties.price_filter(0, @params[:max_price]).sq_feet_filter(@sq_feet, @params[:show_property_type]).built_year_filter(@params[:yearFilter][:from_year].to_i, @params[:yearFilter][:to_year].to_i).escort_filter(@commission).send_escort_filter(@send_commisson).search_filter(@params[:search]).order(created_at: :asc)
    else
      properties = @properties.price_filter(0, @params[:max_price]).sq_feet_filter(@sq_feet, @params[:show_property_type]).escort_filter(@commission).send_escort_filter(@send_commisson).search_filter(@params[:search]).order(created_at: :asc)
    end

    OpenStruct.new(message: 'Properties.', status: 200, properties: ActiveModelSerializers::SerializableResource.new(properties.uniq, each_serializer: PropertySerializer))

  end

end
