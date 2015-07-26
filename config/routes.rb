Rails.application.routes.draw do
  root "home#landing"

  #login and signup routes
  match '/connect' => 'home#connect', via: [:get]
  match '/login' => 'home#login', via: [:post]
  match '/signup' => 'home#signup', via: [:post]
  match '/verify' => 'home#verify', via: [:get]
  match '/fb' => 'home#fb', via: [:post]
  match '/logout' => 'home#logout', via: [:get]
  match '/forgotpassword' => "home#genpassword", via: [:post]

  # dashboard route
  match '/dashboard' => 'dashboard#index', via: [:get]

  #api
  namespace :api, :defaults => {format: :json}  do
    resources :companies do
    end
    resources :jobs do
    end
    match '/addJob' => "jobs#addJob", via: [:get]
    match '/removeJob' => "jobs#removeJob", via: [:get]
    match '/candidates' => "jobs#candidates", via: [:get]
    match '/match' => "jobs#match", via: [:post]
    match '/removematch' => "jobs#removematch", via: [:post]
    match '/mymatches' => "jobs#mymatches", via: [:get]
    match '/user' => "users#index", via: [:get]
    match '/user' => "users#update", via: [:post]
    match '/savedjobs' => "users#savedjobs", via: [:get]
  end

end
