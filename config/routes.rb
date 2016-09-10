Rails.application.routes.draw do
  Rails.application.routes.draw do
    scope module: 'integration' do
      root 'georitm#init'
      get 'georitm/ping' => 'georitm#ping'
      get 'georitm/init' => 'georitm#init'
      get 'georitm/execute' => 'georitm#execute'
    end
  end
end
