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
      retry_limit = 3
      retries = 0
      begin
        json_response = @movie_service.fetch_movies
        if json_response
          retries += 1
        else
          render json: { error: "Actor not found or Wrong input!" }, status: :not_found
        end
      end while json_response && retries < retry_limit

      if retries >= retry_limit
        render json: { error: "Movie service retry limit exceeded" }, status: :internal_server_error
      end
    end
  end

  def initialize_movie_service
    @movie_service = MovieService.new
  end

end
