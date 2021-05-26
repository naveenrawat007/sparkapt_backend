module Api
  class MainController < ActionController::API
      respond_to :json

      private

      def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @decoded = JsonWebToken.decode(header)
          @current_user = User.find(@decoded[:user_id])
        rescue ActiveRecord::RecordNotFound => e
          render json: { error: "User not exists.", status: 401 }, status: 200
        rescue JWT::DecodeError => e
          render json: { error: e.message, status: 401 }, status: 200
        end
      end

      def authorize_assistant_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @decoded = JsonWebToken.decode(header)
          @current_user = User.find_by(id: @decoded[:user_id], is_va: true)
        rescue ActiveRecord::RecordNotFound => e
          render json: { error: "Assistant not exists.", status: 401 }, status: 200
        rescue JWT::DecodeError => e
          render json: { error: e.message, status: 401 }, status: 200
        end
      end

      def get_user
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @decoded = JsonWebToken.decode(header)
          @current_user = User.find(@decoded[:user_id])
        rescue JWT::DecodeError => e
        end
      end

      def authorize_admin_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @decoded = JsonWebToken.decode(header)
          @current_user = User.find_by(id: @decoded[:user_id], is_admin: true)
          if !@current_user
            render json: { error: "User not exists or not admin.", status: 401 }, status: 200 and return
          end
        rescue JWT::DecodeError => e
          render json: { error: e.message, status: 401 }, status: 200
        end
      end

      def check_role
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @decoded = JsonWebToken.decode(header)
          user = User.find_by(id: @decoded[:user_id])
          if user.is_admin
            authorize_admin_request
          elsif user.is_va
            authorize_assistant_request
          end
        rescue JWT::DecodeError => e
          render json: { error: e.message, status: 401 }, status: 200
        end
      end

  end
end
