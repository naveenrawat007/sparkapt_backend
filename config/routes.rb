Rails.application.routes.draw do

  namespace 'api' do
    devise_for :users, controllers:{ sessions: 'api/users/sessions', registrations: 'api/users/registrations' }
    resources :clients
    namespace 'admin' do
      resources :plans
    end
    resources :subscriptions
    post 'users/forgot_password', to: 'users#forgot_password'
    post 'users/reset_password', to: 'users#reset_password'
    get 'users/show', to: 'users#show'
    put "users/update_profile" => "users#update_profile"
    post "users/contact_us" => "users#contact_us"
  end

end
