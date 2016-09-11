Rails.application.routes.draw do
  Rails.application.routes.draw do
    scope module: 'integration' do
      root 'georitm#init'
      get 'georitm/ping' => 'georitm#ping'
      get 'georitm/init' => 'georitm#init'
      post 'georitm/execute' => 'georitm#execute'

      get 'radiotaxi/init' => 'radiotaxi#init'
    end
  end
end
