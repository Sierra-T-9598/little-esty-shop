Rails.application.routes.draw do

  namespace :admin do
    resources :dashboard
    resources :merchants
    resources :invoices
  end

  resources :merchants do
    scope module: :merchants do
      resources :items, :invoices
      resources :dashboard, only: [:index]
      resources :bulk_discounts
    end 
  end
end
