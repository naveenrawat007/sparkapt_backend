class FilterPropertyService

  def initialize(params, properties)
    @params = params
    @properties = properties
  end

  def call
    if @params[:yearFilter][:to_year].present? && @params[:yearFilter][:from_year].present? && !@params[:commission].present?
      properties = @properties.price_filter(0, @params[:max_price]).built_year_filter(@params[:yearFilter][:from_year].to_i, @params[:yearFilter][:to_year].to_i).search_filter(@params[:search]).order(created_at: :asc)
    elsif @params[:commission].present? && !@params[:yearFilter][:to_year].present? && !@params[:yearFilter][:from_year].present?
      properties = @properties.price_filter(0, @params[:max_price]).escort_filter(@params[:commission].to_i).search_filter(@params[:search]).order(created_at: :asc)
    elsif @params[:yearFilter][:to_year].present? && @params[:yearFilter][:from_year].present? && @params[:commission].present?
      properties = @properties.price_filter(0, @params[:max_price]).built_year_filter(@params[:yearFilter][:from_year].to_i, @params[:yearFilter][:to_year].to_i).escort_filter(@params[:commission].to_i).search_filter(@params[:search]).order(created_at: :asc)
    else
      properties = @properties.price_filter(0, @params[:max_price]).search_filter(@params[:search]).order(created_at: :asc)
    end

    OpenStruct.new(message: 'Properties.', status: 200, properties: ActiveModelSerializers::SerializableResource.new(properties, each_serializer: PropertySerializer))

  end

end
