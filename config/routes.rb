Rails.application.routes.draw do

  namespace 'api' do
    devise_for :users, controllers:{ sessions: 'api/users/sessions', registrations: 'api/users/registrations' }

    get 'users/forgot_password', to: 'users#forgot_password'
    post 'users/update_password', to: 'users#update_password'
    get 'users/show', to: 'users#show'
    put "users/update_profile" => "users#update_profile"

  end

end
