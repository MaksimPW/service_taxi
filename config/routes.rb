Rails.application.routes.draw do
  Rails.application.routes.draw do
    scope module: 'integration' do
      root 'georitm#init'
      get 'georitm/ping' => 'georitm#ping'
      get 'georitm/init' => 'georitm#init'
      post 'georitm/execute' => 'georitm#execute'

      post 'radiotaxi/cars' => 'radiotaxi#cars'
      post 'radiotaxi/drivers' => 'radiotaxi#drivers'
      post 'radiotaxi/orders/:take_date' => 'radiotaxi#orders'
    end
  end
end
