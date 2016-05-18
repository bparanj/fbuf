Rails.application.routes.draw do
  get 'welcome/about', to: 'welcome#about', as: :about

  resources :movies do
  	collection do
  		get 'search'
  	end
    resources :reviews
  end

  root 'movies#index'
end
