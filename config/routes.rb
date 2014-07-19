Rails.application.routes.draw do
  root to: 'pages#index'
  get 'show' => 'pages#show'
  get 'about' => 'pages#about'
end
