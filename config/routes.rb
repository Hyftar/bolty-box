Rails.application.routes.draw do
  root 'static_pages#home'
  get 'help', to: 'static_pages#help'
  get 'about', to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'

  resources :assets, except: %i[new] do
    get 'download', to: 'assets#download', as: 'download', on: :member
  end

  resources :directories do
    resources :assets, only: %i[new]
  end

  get 'share', to: 'directories#share'

  devise_for :users, skip: :all
  devise_scope :user do
    scope :users do
      get 'sign_in', to: 'devise/sessions#new', as: 'new_user_session'
      post 'sign_in', to: 'devise/sessions#create', as: 'user_session'
      delete 'sign_out', to: 'devise/sessions#destroy', as: 'destroy_user_session'
      get 'password/new', to: 'devise/passwords#new', as: 'new_user_password'
      get 'password/edit', to: 'devise/passwords#edit', as: 'edit_user_password'
      patch 'password', to: 'devise/passwords#update', as: 'user_password'
      put 'password', to: 'devise/passwords#update'
      post 'password', to: 'devise/passwords#create'
      get 'sign_up', to: 'registrations#new', as: 'new_user_registration'
      get 'edit', to: 'registrations#edit', as: 'edit_user_registration'
      patch '', to: 'registrations#update', as: 'user_registration'
      put '', to: 'registrations#update'
      post '', to: 'registrations#create'
      get 'confirmation/new', to: 'devise/confirmations#new', as: 'new_user_confirmation'
      get 'confirmation', to: 'devise/confirmations#show', as: 'user_confirmation'
      post 'confirmation', to: 'devise/confirmations#create', as: ''
      get 'unlock/new', to: 'devise/unlocks#new', as: 'new_user_unlock'
      get 'unlock', to: 'devise/unlocks#show', as: 'user_unlock'
      post 'unlock', to: 'devise/unlocks#create'
    end
  end
end
