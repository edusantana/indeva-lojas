Rails.application.routes.draw do
  get 'metas/show'

  devise_for :users
  resources :lojas do
    resources :metas, only: [:index, :show]
  end
  get 'home/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root to: "home#index"
  
end
