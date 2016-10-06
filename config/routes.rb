Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'rails_admin/main#dashboard'

  use_doorkeeper
  devise_for :users

  resources :orders, only: [:index, :show]

  scope module: 'integration' do
    get 'georitm/ping' => 'georitm#ping'
    get 'georitm/init' => 'georitm#init'
    post 'georitm/execute' => 'georitm#execute'

    post 'radiotaxi/cars' => 'radiotaxi#cars'
    post 'radiotaxi/drivers' => 'radiotaxi#drivers'
    post 'radiotaxi/orders' => 'radiotaxi#orders'
  end

  namespace :api do
    namespace :v1 do
      resources :api_waybills, only: [:create, :update] do
        get :ping, on: :collection
      end
    end
  end
end
