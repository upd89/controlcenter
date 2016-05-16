Rails.application.routes.draw do
  get 'login' => 'user_sessions#new', :as => :login
  get 'logout' => 'user_sessions#destroy', :as => :logout

  root 'systems#index'
  resources :tasks
  resources :combinations
  resources :jobs
  resources :task_executions
  resources :users
  resources :user_sessions
  resources :roles
  resources :task_states
  resources :group_assignments
  resources :packages
  resources :package_groups
  resources :systems
  resources :system_groups
  resources :concrete_package_versions
  resources :concrete_package_states
  resources :package_versions
  resources :distributions
  resources :repositories

  post '/jobs/test' => 'jobs#test'

  scope '/api' do
    scope module: 'api' do
      namespace :v1 do
        match "/register" => "api#register", via: :post
        match "/system/:id/notify" => "api#updateSystem", via: :post
        match "/task/:id/notify" => "api#updateTask", via: :post
        match "/system/:id/updateInstalled" => "api#updateInstalled", via: :post
      end

      namespace :v2 do
        match "/register"                           => "api#register", via: :post
        match "/system/:urn/notify-hash"            => "api#updateSystemHash", via: :post
        match "/system/:urn/notify"                 => "api#updateSystem", via: :post
        match "/system/:urn/refresh-installed-hash" => "api#refreshInstalledHash", via: :post
        match "/system/:urn/refresh-installed"      => "api#refreshInstalled", via: :post
        match "/task/:id/notify"                    => "api#updateTask", via: :post
      end
    end
  end
end
