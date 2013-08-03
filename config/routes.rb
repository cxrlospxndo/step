Step::Application.routes.draw do
  match "/auth/:provider/callback" => "facebook#create"
  match "/auth/failure" => "facebook#failure"
  match "/facebook" => "facebook#create"
  root to: 'sample#main'
  get '/login' => 'session#new', :as => :login
  post '/login' => 'session#create', :as => :login
  match '/signout' => 'session#destroy', :as => :signout
  match '/sample' => 'sample#index', :as => :sample
  match '/notas' => 'session#show'
end
