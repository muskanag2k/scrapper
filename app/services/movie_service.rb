class MovieService

  def fetch_movies
    url = 'https://www.imdb.com/chart/top/?ref_=nv_mv_mpm'
    response = HTTP.headers('User-Agent' => 'Mozilla/5.0').get(url)
    if response.status.success?
      body = response.body.to_s
      html = Nokogiri::HTML(body)
      script_tag = html.at('script[type="application/ld+json"]')
      json_data = JSON.parse(script_tag.content)
      items = json_data['itemListElement']
      items.each do |item|
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
          # rescue StandardError => e
          #   puts "Error fetching or parsing data for #{movie_name}: #{e.message}"
          end
        rescue StandardError => e
          puts "Exception occurred in thread: #{e.message}"
        end
      end
      puts "Fetch completed.."
      json_data
    else
      puts "Error fetching the IMDb Top 250 page: #{response.status}"
    end
  end

end
