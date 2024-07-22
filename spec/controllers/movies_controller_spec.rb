require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe 'GET #print_top_movies' do
    it 'fetches and prints top N movies' do
      get :print_top_movies, params: { n: 5 }
      expect(JSON.parse(response.body)['movies'].size).to eq(5)
      puts JSON.parse(response.body)
    end
  end

  describe 'GET #fetch_movies_by_actor' do
    it 'fetches movies by actor' do
      get :fetch_movies_by_actor, params: { actor_name: "Frank Darabont"}
      json_response = JSON.parse(response.body)
      puts json_response
    end

    it 'returns error if actor not found' do
      get :fetch_movies_by_actor, params: { actor_name: 'Nonexistent Actor' }
      expect(JSON.parse(response.body)).to eq({ 'error' => 'Actor not found' })
    end
  end
end



#specs
#validation, unique
#model, controller
#service
#coverage report simplecov
