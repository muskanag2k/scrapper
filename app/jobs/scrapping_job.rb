class ScrappingJob < ApplicationJob

  def perform
    @redis = Redis.new(url: ENV['REDIS_URL'])
    url = 'https://www.imdb.com/chart/top/?ref_=nv_mv_mpm'
    cached_data = @redis.get(url)
    json_data = MovieService.new.fetch_movies
    encoded_string = json_to_fixed_size_string(json_data)
    if !cached_data or cached_data != encoded_string
      @redis.set(url, encoded_string)
    end
  end

  def json_to_fixed_size_string(json_data)
    json_string = json_data.to_json
    hashed_string = Digest::SHA1.hexdigest(json_string)
    fixed_size_string = hashed_string[0, 10]
    fixed_size_string
  end

end
