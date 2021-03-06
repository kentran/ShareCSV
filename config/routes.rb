Rails.application.routes.draw do
  get 'show' => 'pages#show'
  get 'about' => 'pages#about'

  root 'pastes#index'

  get 'dl/:slug/:filename' => 'pastes#download', as: 'download_csv', :constraints  => { :filename => /.*/ }

  get 's/:slug/:filename' => 'pastes#show',
      :as => 'show_csv', :defaults => {:format => 'html'}, :constraints  => { :filename => /.*/ }
      
  resources :pastes
end
