Rails.application.routes.draw do
  root 'csv_for_shares#index'

  get ":link_id/:original_file_name" => "csv_for_shares#show", 
                    :as => "show_csv", :defaults => { :format => 'html' }

  resources :csv_for_shares
end
