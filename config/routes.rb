class ApiSubdomain
  def self.matches? request
    return true if request.subdomain === "api"
    return true if request.port === 4000
    return false
  end   
end

class AdminSubdomain
  def self.matches? request
    return true if request.subdomain === "admin"
    return true if request.port === 3000
    return false
  end   
end

Rails.application.routes.draw do
  
  constraints(AdminSubdomain) do
    devise_for :admin_users, ActiveAdmin::Devise.config
    root to: "admin/dashboard#index"
    ActiveAdmin.routes(self)
  end

  constraints(ApiSubdomain) do
    resources :videos, controller: 'videos', only: [:index, :show]
  end
  
end