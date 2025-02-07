Rails.application.routes.draw do
  resources :documents, only: [ :index, :new, :create, :destroy ] do
    member do
      get :download
    end
  end

  root "documents#index"
end
