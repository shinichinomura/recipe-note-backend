Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post "/login", to: "login#login"
  post "/logout", to: "secure/logout#logout"
  post "/signup", to: "user_accounts#create"
end
