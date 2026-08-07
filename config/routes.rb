Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  root "landing#index"
  post "contact", to: "contact#create"
  get "jobs/:slug", to: "landing#show_job", as: :job_detail
  get "up" => "rails/health#show", as: :rails_health_check

  get "admin-candidats", to: "admin/candidates#index"
  get "admin-candidats/nouveau", to: "admin/candidates#new", as: :new_admin_candidate
  post "admin-candidats", to: "admin/candidates#create", as: :admin_candidates
  get "admin-candidats/:id/modifier", to: "admin/candidates#edit", as: :edit_admin_candidate
  patch "admin-candidats/:id", to: "admin/candidates#update", as: :admin_candidate
  get "admin-candidats/:id/download_cv", to: "admin/candidates#download_cv", as: :admin_candidate_download_cv
  delete "admin-candidats/:id", to: "admin/candidates#destroy", as: :admin_candidate_destroy

end
