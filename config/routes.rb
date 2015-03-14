Rails.application.routes.draw do
  resources :users, except: [:index] do
    resources :subs, only: [:new]
    resources :posts, only: [:new]
  end
  resource :session, only: [:new, :create, :destroy]
  resources :subs, except: [:destroy, :new]
  resources :posts, except: [:destroy, :new]
end
