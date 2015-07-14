Rails.application.routes.draw do
  root "home#landing"
  match '/login' => 'home#login', via: [:get]
end
