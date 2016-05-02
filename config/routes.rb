Rails.application.routes.draw do
  root 'systems#index'
  resources :tasks
  resources :jobs
  resources :task_executions
  resources :users
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

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
