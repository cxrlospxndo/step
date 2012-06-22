Step::Application.routes.draw do
  resources :users
  #match "/:codigo" => "users#show"
  match "/auth/:provider/callback" => "facebook#create"
  match "/auth/failure" => "facebook#failure"
  match "/facebook" => "facebook#create"
  root to: "users#index"
end
