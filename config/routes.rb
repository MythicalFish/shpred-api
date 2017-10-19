Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  root to: "admin/dashboard#index"
  ActiveAdmin.routes(self)

  namespace :api do
    get '/videos', to: 'videos#index'
  end
  
end
