Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  root 'dummy#index'

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
      resources :api_waybills, only: :create do
        get :ping, on: :collection
      end
    end
  end
end
