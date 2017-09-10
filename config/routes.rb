Rails.application.routes.draw do
  resources :tasks
  resources :orders do
    get 'balo', on: :collection
    get 'purge', on: :collection
    get 'daily', on: :collection
    get 'download', on: :collection
  end

  resources :repays
  resources :products do
    get 'balo', on: :collection
    get 'purge', on: :collection
  end

  resources :import_orders

  root 'orders#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
