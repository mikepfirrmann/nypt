Nyptr::Application.routes.draw do
  match '(from/(:origin(/to(/:destination(/on(/:on))))))' => 'schedule#index'
  match '(to/(:destination))' => 'schedule#index'

  match 'trips/:id(/from/(:origin(/to(/:destination(/on(/:on))))))' => 'trips#show'
  match 'trips/:id(/to/:destination)' => 'trips#show'

  root :to => 'schedule#index'
end
