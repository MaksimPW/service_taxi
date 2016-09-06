Rails.application.routes.draw do
  Rails.application.routes.draw do
    scope module: 'integration' do
      root 'georitm#init'
      get 'georitm/init' => 'georitm#init'
      get 'georitm/index' => 'georitm#index'
    end
  end
end
