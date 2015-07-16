Rails.application.routes.draw do
  root "home#landing"

  #login and signup routes
  match '/connect' => 'home#connect', via: [:get]
  match '/login' => 'home#login', via: [:post]
  match '/signup' => 'home#signup', via: [:post]
  match '/verify' => 'home#verify', via: [:get]
  match '/fb' => 'home#fb', via: [:post]
  match '/logout' => 'home#connect', :logout => true, via: [:get]

  # dashboard route
  match '/dashboard' => 'dashboard#index', via: [:get]

  #api
  namespace :api, :defaults => {format: :json}  do
    resources :companies do
    end
    resources :jobs do
    end
  end

end
