Rails.application.routes.draw do

  namespace 'api' do
    devise_for :users, controllers:{ sessions: 'api/users/sessions', registrations: 'api/users/registrations' }
    resources :clients
    resources :subscriptions

    # admin_routes
    get "admin/inquiry_list" => "admins#contact_inquiry_list"
    post "admin/subscriptions" => "admins#subscription_list"
    get "admin/plans" => "admins#plans_list"
    get "admin/users" => "admins#users_list"

    # user_routes
    post 'users/forgot_password', to: 'users#forgot_password'
    post 'users/reset_password', to: 'users#reset_password'
    get 'users/show', to: 'users#show'
    put "users/update_profile" => "users#update_profile"
    post "users/contact_us" => "users#contact_us"
    post 'search_client' => "clients#search_client"

  end

end
