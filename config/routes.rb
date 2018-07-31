Rails.application.routes.draw do
  scope "(:locale)", :locale => /en|vi/ do
    root "static_pages#home"
    get "/listword", to: "filters#listword"
    get "/listword_category/:id", to: "filters#listword_category"
    get "/listword_alphabet", to: "filters#listword_alphabet"
    get "/listword_learned/:status", to: "filters#listword_learned"
    get "/word", to: "static_pages#word"
    get "/choose_category", to: "choose_category#choose_category"
    get "/signup", to: "users#new"
    get "/profile", to: "users#show"
    get "/edit", to: "users#edit"
    get "/admin", to: "users#admin"
    post "/lesson_logs/:id", to: "lesson_logs#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    get "login_google", to: redirect("/auth/google_oauth2")
    get "auth/:provider/callback", to: "sessions#create_google"
    get "auth/failure", to: redirect("/")
    delete "/logout", to: "sessions#destroy"
    get "follow", to: "users#follow"
    get "unfollow", to: "users#unfollow"
    get "/question_logs/:id", to: "question_logs#update"
    get "/restore_questions", to: "questions#restore"
    get "/restore_categories", to: "categories#restore"
  end

  resources :questions
  resources :users
  resources :lesson_logs, only: %i(create show update edit)
  resources :lessons
  resources :courses
  resources :categories
  resources :follow_users, only: %i(create destroy)
  resources :account_activations, only: %i(edit)
  resources :password_resets, only: %i(new create edit update)
end
