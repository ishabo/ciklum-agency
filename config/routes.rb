CiklumAgency::Application.routes.draw do

  resources :bonus_schemes


  resources :service_types

  root :to => 'home#index'

  get "logout" => "home#logout"
  get "login" => "home#login"
  post "login" => "home#login"
  
  match '/service_project_form', :to => 'services#upsert_form', via: [:get, :post]
  match '/service_project_form/:service_id', :to => 'services#upsert_form', via: [:get, :post]

  match '/home', :to => "home#index", via: [:get]

  post "/update_user_availability/:id" => "application#update_user_availability"

  resources :services

  resources :projects

  resources :positions

  resources :users


  match "bonuses" => "bonuses#index", via: [:get]

  match "/bonuses/:id" => "bonuses#index", :as => 'bonuses_claimed', via: [:get]

  post "/bonuses/update_value/:id" => "bonuses#update_value", via: [:get, :post]

  match "claim_bonus" => "bonuses#claim", via: [:get]

  match "pay_bonus" => "bonuses#pay", via: [:get]

  match "/batch_pay_bonus" => "bonuses#batch_pay", via: [:get]

  match "/prep_bonus_payments" => "bonuses#prep_payments", via: [:get]



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
