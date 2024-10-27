Rails.application.routes.draw do
  resources :administrations, except: %i[index show ]
  resources :posts, except: %i[show ]
  devise_for :users, skip: [:registration]
  root "homes#index"

  get "management", to: "homes#management"
  get "institute", to: "homes#institute"
  get "administration", to: "homes#administration", as: :static_administration
  get "vision_and_mission", to: "homes#vision_and_mission"
end
