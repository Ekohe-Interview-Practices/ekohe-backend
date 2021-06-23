Rails.application.routes.draw do
  resources :books do
    member do
      post 'borrow'
      post 'returns'
      get 'status'
      get 'income'
    end
  end
  resources :accounts do
    get 'status', on: :member
  end
  root "info#index"
end
