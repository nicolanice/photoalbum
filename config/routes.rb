Filmbase::Application.routes.draw do  

  resources :albums

  resources :histories

  resources :images

  resources :users

  resource :session, :only => [:new, :create, :destroy]
  
  #post "versions/:id/revert" => "versions#revert", :as => "revert_version"

  
  match "/images/:id/mark_sub" => "images#mark_sub", :as => "mark_sub"

  match "/images/destroy_images" => "images#destroy_images", :as => "destroy_images"
  
  
  match "/images/:id/mark_add" => "images#mark_add", :as => "mark_add"

  match 'signup' => 'users#new', :as => :signup

  match 'register' => 'users#create', :as => :register

  match 'login' => 'sessions#new', :as => :login

  match 'logout' => 'sessions#destroy', :as => :logout

  match '/activate/:activation_code' => 'users#activate', :as => :activate, :activation_code => nil
  
  match "/albums/:id/clean_history" => "albums#clean_history", :as => "clean_history"
  match "/albums/:id/:image_id/change_cover" => "albums#change_cover", :as => "change_cover"
  
  resources :albums do
      resources :images
  end
  
  resources :users do
      resources :albums
  end
  
  resources :albums do
      resources :histories
  end
  

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
   root :to => "albums#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
