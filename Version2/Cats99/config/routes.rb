Rails.application.routes.draw do
  resources :cats
  resources :cat_rental_requests do
    member do
      patch :approve
      patch :deny
    end
  end

  resource :user, only: [:create, :new, :show]
  resource :session, only: [:create, :destroy, :new]

  root to: "cats#index"
end
