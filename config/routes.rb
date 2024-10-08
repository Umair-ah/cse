Rails.application.routes.draw do
  resources :posts, except: %i[show ]
  devise_for :users, skip: [:registration]
  root "homes#index"
end
