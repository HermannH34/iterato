Rails.application.routes.draw do
  root "landing#index"
  post "contact", to: "contact#create"
  get "jobs/:slug", to: "landing#show_job", as: :job_detail
  get "up" => "rails/health#show", as: :rails_health_check
end
