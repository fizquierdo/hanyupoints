Rails.application.routes.draw do
  devise_for :users
  resources :words
  resources :grammar_points
  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  get 'grammar_points/:id/examples' => 'grammar_points#examples', as: :examples
  get 'examples' => 'grammar_points#list_examples', as: :list_examples
	
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  get '/home', to:'static#home', as: :home
	root 'static#home'

  # specific networks
  get '/network', to:'static#network'
  get '/network_HSK1', to:'static#network_HSK1'
  get '/network_HSK2', to:'static#network_HSK2'
  get '/network_HSK3', to:'static#network_HSK3'
  get '/tone_network', to:'static#tone_network'

  # this below looks quite ugly, cant we pass the level in the URL?
  get 'grammar_tree_A1', to:'static#grammar_tree_A1'
  get 'grammar_tree_A2', to:'static#grammar_tree_A2'
  get 'grammar_tree_B1', to:'static#grammar_tree_B1'
  get 'grammar_tree_B2', to:'static#grammar_tree_B2'

  get 'flashcards/' => 'flashcards#flashcards'
  patch '/flashcards/:id/check' => 'flashcards#check', as: :check
  post '/flashcards/:id/play' => 'flashcards#play', as: :play

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
