Rails.application.routes.draw do
  get 'cart_items/increment'
  get 'cart_items/decrement'
  get 'carts/show'
  # Робимо products#index головною сторінкою
  root 'products#index'

  # Створюємо маршрути для продуктів, включаючи дії index, show, new, і create
  resources :products, only: [:index, :show, :new, :create] do
    member do
      get 'details', to: 'products#show_product'
    end
    resources :reviews, only: [:create]  # Додано для обробки відгуків
  end

  # Маршрути для авторизації та реєстрації
  post 'signup', to: 'users#create', as: 'signup'
  post 'login', to: 'sessions#create', as: 'login'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  # Маршрути для профілю користувача
  get '/profile', to: 'users#edit', as: 'profile'
  patch '/profile', to: 'users#update'

  # Маршрути для корзини
  get 'cart', to: 'carts#show', as: 'cart'
  patch 'cart_item/:id/increment', to: 'cart_items#increment', as: 'increment_cart_item'
  patch 'cart_item/:id/decrement', to: 'cart_items#decrement', as: 'decrement_cart_item'
  post 'cart_items/:product_id', to: 'cart_items#create', as: 'add_to_cart'
end
