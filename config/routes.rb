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
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
