Rails.application.routes.draw do
  resources :batches do
    collection do
      post :upload
    end
  end

  resources :projects, except: :show

  resources :guides, only: %i[show create destroy] do
    collection do
      post :upload
      get :display_guides
      get :guide_login
      get :guide_logged_in
      post :clean
      post :update_guide
      post :update_mini
      post :update_major

      post :remove_project

    end
  end
  
  resources :news, except: %i[index show ]
  resources :faculties, except: %i[show ]
  resources :administrations, except: %i[index show ]
  resources :posts, except: %i[show ]
  devise_for :users, skip: [:registration]
  root "homes#index"

  get "management", to: "homes#management"
  get "institute", to: "homes#institute"
  get "administration", to: "homes#administration", as: :static_administration
  get "vision_and_mission", to: "homes#vision_and_mission"

  get "overview", to: "homes#overview"
  get "programmes", to: "homes#programmes"
  get "fee", to: "homes#fee"


  post "search", to: "batches#search", as: :search
end
