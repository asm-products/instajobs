Rails.application.routes.draw do
  root "home#landing"
  match '/connect' => 'home#connect', via: [:get]
  match '/login' => 'home#login', via: [:post]
  match '/signup' => 'home#signup', via: [:post]
  match '/verify' => 'home#verify', via: [:get]
end
