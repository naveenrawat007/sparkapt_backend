Rails.application.routes.draw do

  namespace 'api' do
    devise_for :users, controllers:{ sessions: 'api/users/sessions', registrations: 'api/users/registrations' }
    resources :clients
    resources :subscriptions
    namespace 'admin' do
      resources :notifications
      resources :properties
      resources :leads
      get "/property_types" => "properties#get_property_types"
      get "/get_markets" => "properties#get_markets"

      get "/latest_notification" => "notifications#get_latest_notification"
      post "/filter_property" => "properties#filter_property"
      post "/get_properties" => "properties#get_properties"
      post "/import_properties" => "properties#import_properties"
      post "/get_lat_longs" => "properties#get_lat_longs"
      post "/properties_locations" => "properties#properties_locations"
      put "/properties/va_update_property/:id" => "properties#va_update_property"
      post "/selected_locations" => "properties#selected_locations"


      # virtual assistant CRUD routes

      get '/virtual_assistants' => "assistants#assistants_list"
      post '/virtual_assistants' => "assistants#create_virtual_assistant"
      delete '/virtual_assistants/:id' => "assistants#destroy_assistant"
      get '/virtual_assistants/:id' => "assistants#show"
      put '/virtual_assistants/:id' => "assistants#update_assistant"


    end

    # admin_routes
    get "admin/inquiry_list" => "admins#contact_inquiry_list"
    post "admin/subscriptions" => "admins#subscription_list"
    get "admin/plans" => "admins#plans_list"
    get "admin/users" => "admins#users_list"
    post "admin/search_user" => "admins#search_user"
    post "admin/login_as" => "admins#login_as_user"
    get "admin/get_admin_name" => "admins#admin_name"
    post "admin/approve_user" => "admins#approve_user"

    # user_routes
    post '/multiple_report' => "users#multiple_report"
    post '/send_report' => "users#send_property_report"
    get 'cities' => "users#get_cities"
    get 'clients_list' => "clients#client_list"
    get 'custom_client_list' => "clients#custom_client_list"
    post '/client_status' => "clients#client_status"
    post 'users/forgot_password', to: 'users#forgot_password'
    post 'users/reset_password', to: 'users#reset_password'
    post 'users/update_password', to: 'users#update_password'
    get 'users/show', to: 'users#show'
    put "users/update_profile" => "users#update_profile"
    post "users/contact_us" => "users#contact_us"
    post 'search_client' => "clients#search_client"

    # property_report routes

    post "/properties_report" => "reports#properties_report"
    get "/my_reports" => "reports#index"
    post "/tour_request" => "reports#tour_request"

  end

end
