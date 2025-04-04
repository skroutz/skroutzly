Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Authenticated routes
  authenticated :user do
    resources :short_urls do
      member do
        post "reset_stats"
      end
    end
    root "short_urls#index", as: :authenticated_root
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # This should always be the last route in the file, as it will catch all unmatched routes.
  get "/:slug" => "short_urls#redirect", as: "redirect"

  # Defines the root path route ("/")
  root "pages#home"
end
