Rails.application.routes.draw do
  scope "(:locale)", :locale => /en|vi/ do
    root "static_pages#home"
    get "/home", to: "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/listword", to: "filters#listword"
    get "/listword_category/:id", to: "filters#listword_category"
    get "/listword_alphabet", to: "filters#listword_alphabet"
    get "/listword_learned/:status", to: "filters#listword_learned"
    get "/word", to: "static_pages#word"
    get "/signup", to: "users#new"
    get "/profile", to: "users#show"
    get "/edit", to: "users#edit"
    get "/admin", to: "users#admin"
    post "/lession/:id", to: "lession_logs#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
  end
  resources :answers
  resources :questions 
  resources :users
  resources :lession_logs
  resources :lessions
  resources :courses
  resources :categories
end
