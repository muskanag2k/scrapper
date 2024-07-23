class ActorsController < ApplicationController
  before_action :initialize_movie_service

  def show
    actor_name = params[:actor_name]
    m = params[:input]
    actor = Actor.find_by(name: actor_name)
    if actor
      movies = actor.movies.limit(m)
      movie_list = movies.map.with_index(1) do |movie, index|
        { position: index, title: movie.title }
      end

      render json: {
        actor: actor_name,
        top_movies: movie_list
      }
    else
      json_response = @movie_service.fetch_movies
      if json_response
        show
      else
        render json: { error: "Actor not found or Wrong input!" }, status: :not_found
      end
    end
  end

  def initialize_movie_service
    @movie_service = MovieService.new
  end

end
