Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'print_top_movies/:n', to: 'movies#print_top_movies'
  get 'fetch_movies_by_actor/:actor_name(/:m)', to: 'movies#fetch_movies_by_actor'
end
