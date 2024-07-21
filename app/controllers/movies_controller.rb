class MoviesController < ApplicationController

  def fetch_movies
    url = 'https://www.imdb.com/chart/top/?ref_=nv_mv_mpm'
    response = HTTP.headers('User-Agent' => 'Mozilla/5.0').get(url)
    if response.status.success?
      body = response.body.to_s
      html = Nokogiri::HTML(body)
      script_tag = html.at('script[type="application/ld+json"]')
      json_data = JSON.parse(script_tag.content)
      json_data
    else
      puts "Error fetching the IMDb Top 250 page: #{response.status}"
    end
  end

  #print top N movies
  def print_top_movies
    n = params[:n].to_i
    json_data = fetch_movies
    items = json_data['itemListElement']
    items.first(n).each do |item|
      movie_name = item['item']['name']
      movie = Movie.find_or_create_by(title: movie_name)
      Thread.new do
        begin
          cast_url = item['item']['url']
          cast_response = HTTP.headers('User-Agent' => 'Mozilla/5.0').get(cast_url)

          if cast_response.status.success?
            cast_body = cast_response.body.to_s
            cast_html = Nokogiri::HTML(cast_body)
            actors = cast_html.css('a[href^="/name/"]').map { |actor| actor.text.strip }.uniq.reject(&:empty?)
            actors.each do |actor_name|
              actor = Actor.find_or_create_by(name: actor_name)
              ActorMovie.find_or_create_by(movie_id: movie.id, actor_id: actor.id)
            end
          else
            puts "Error fetching cast page for #{movie_name}: #{cast_response.status}"
          end
        rescue StandardError => e
          puts "Error fetching or parsing data for #{movie_name}: #{e.message}"
        end
      end
    end
    print_movies (n)
  rescue StandardError => e
    puts "Error fetching or parsing data: #{e.message}"
  end

  def print_movies(n = 5)
    @movies = Movie.limit(n)
    movie_titles = @movies.map { |movie| movie.title}

    render json: { movies: movie_titles }
  end

  #fetch movies as per the actor input
  def fetch_movies_by_actor
    actor_name = params[:actor_name]
    m = params[:m].present? ? params[:m].to_i : 1  # Default m to 1 if not provided
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
      render json: { error: "Actor not found" }, status: :not_found
    end
  end

  #cron job
  def keep_check
    @redis = Redis.new(url: ENV['REDIS_URL'])
    url = 'https://www.imdb.com/chart/top/?ref_=nv_mv_mpm'
    cached_data = @redis.get(url)
    json_data = fetch_movies
    encoded_string = json_to_fixed_size_string(json_data)
    if !cached_data or cached_data != encoded_string
      insert_updated_movies(json_data)
      @redis.set(url, encoded_string)
    end
  end

  def json_to_fixed_size_string(json_data)
    json_string = json_data.to_json
    hashed_string = Digest::SHA1.hexdigest(json_string)
    fixed_size_string = hashed_string[0, 10]
    fixed_size_string
  end

  #insert any new movie updated on the IMDb site
  def insert_updated_movies(data)
    if data
      json_data = data
      items = json_data['itemListElement']

      items.each do |item|
        movie_name = item['item']['name']
        movie_id = Movie.find_or_create_by(title: movie_name)
        cast_url = item['item']['url']

        Thread.new do
          actors = fetch_actors(cast_url)
          actors.each do |actor_name|
            actor = Actor.find_or_create_by(name: actor_name)
            movie.actors << actor unless movie.actors.include?(actor)
          end
        end
      end
    else
      puts "Error fetching the IMDb Top 250 page: #{response.status}"
    end

  rescue StandardError => e
    puts "Error fetching or parsing data: #{e.message}"
  end

end
