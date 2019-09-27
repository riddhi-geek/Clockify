Rails.application.routes.draw do
  devise_for :users
  resources :shifts do
  	member do
  		post 'clock_in'
  		post 'clock_out'
  	end
    resources :clock_events, only: [:destroy, :edit, :update]
  end


  # Root path
  root to: 'shifts#index'

  # Routes for missing path
  match '/*path', via: :all, to: 'application#missing_path'
end
