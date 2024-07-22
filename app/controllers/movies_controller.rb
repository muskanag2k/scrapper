class MoviesController < ApplicationController
  before_action :initialize_movie_service

  def show
    n = params[:id].to_i
    @movies = Movie.limit(n)
    if @movies.empty?
      @movie_service.fetch_movies
    end

    movie_titles = @movies.map { |movie| movie.title}
    render json: { movies: movie_titles }
  rescue StandardError => e
    puts "Error fetching or parsing data: #{e.message}"
  end

  private

  def initialize_movie_service
    @movie_service = MovieService.new
  end

end
