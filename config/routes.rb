Rails.application.routes.draw do
  devise_for :users, :controllers => {
    # omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root to: 'home#index'

  resources :users, only: [:update] do
    member do
      get 'complete_signup' => 'users#complete_signup'
    end
  end
end
