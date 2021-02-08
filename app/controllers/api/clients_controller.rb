module Api
  class ClientsController < MainController
    before_action :authorize_request

    def index
      if @current_user
        clients = @current_user.clients.order(created_at: :asc)
        render json: { message: "Clients List.", status: 200, clients: ActiveModelSerializers::SerializableResource.new(clients, each_serializer: ClientSerializer)} and return
      else
        render json: { message: "User not found", status: 400}
      end
    end

    def create
      if @current_user
        client = @current_user.clients.new(client_params)
        if client.save
          clients = @current_user.clients.order(created_at: :asc)
          render json: { message: "Client created sucessfully.", status: 200, clients: ActiveModelSerializers::SerializableResource.new(clients, each_serializer: ClientSerializer)} and return
        else
          render json: { message: "Client not created.", status: 400} and return
        end
      else
        render json: { message: "User not found", status: 400}
      end
    end

    def destroy
      if @current_user && params[:id].present?
        client = @current_user.clients.find_by(id: params[:id])
        if client
          client.destroy
          clients = @current_user.clients.order(created_at: :asc)
          render json: { message: "Client delete sucessfully.", status: 200, clients: ActiveModelSerializers::SerializableResource.new(clients, each_serializer: ClientSerializer)} and return
        else
          render json: { message: "Client not found", status: 400} and return
        end
      else
        render json: { message: "User not found", status: 400}
      end
    end

    def update
      if @current_user && params[:id].present?
        client = @current_user.clients.find_by(id: params[:id])
        if client
          if client.update(client_params)
            clients = @current_user.clients.order(created_at: :asc)
            render json: { message: "Client update sucessfully.", status: 200, clients: ActiveModelSerializers::SerializableResource.new(clients, each_serializer: ClientSerializer)} and return
          else
            render json: { message: "Client not update", status: 400} and return
          end
        else
          render json: { message: "Client not found", status: 400} and return
        end
      else
        render json: { message: "User not found", status: 400}
      end
    end

    def show
      if @current_user && params[:id].present?
        client = @current_user.clients.find_by(id: params[:id])
        if client
        render json: { message: "Client Infomation", status: 200, client: ClientSerializer.new(client,root: false)}
        else
          render json: { message: "Client not found", status: 400} and return
        end
      else
        render json: { message: "User not found", status: 400}
      end
    end

    private

    private
    def client_params
      params.require(:client).permit(:first_name, :last_name, :email, :phone, :notes, :budget, :move_in_date)
    end

  end
end
