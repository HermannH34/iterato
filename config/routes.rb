Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  root "landing#index"
  post "contact", to: "contact#create"
  get "jobs/:slug", to: "landing#show_job", as: :job_detail
  get "up" => "rails/health#show", as: :rails_health_check

  get "admin-candidats", to: "admin/candidates#index"
  get "admin-candidats/:id/download_cv", to: "admin/candidates#download_cv", as: :admin_candidate_download_cv

end
