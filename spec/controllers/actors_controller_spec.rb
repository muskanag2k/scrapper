require 'rails_helper'

RSpec.describe ActorsController, type: :controller do
  describe 'GET #show' do
    it 'fetches movies by actor name' do
      get :show, params: { actor_name: 'Morgan Freeman', input: 1 }
      json_response = JSON.parse(response.body)
      puts json_response
    end

    it 'returns error if actor not found' do
      get :show, params: { actor_name: 'Nonexistent Actor', input: 1 }
      expect(JSON.parse(response.body)).to eq({ 'error' => 'Actor not found or Wrong input!' })
    end

    context 'when movie service returns JSON response' do
      before do
        allow_any_instance_of(MovieService).to receive(:fetch_movies).and_return({ movies: [] })
      end

      it 'retries to fetch movies' do
        get :show, params: { actor_name: 'Nonexistent Actor', input: 2 }
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Movie service retry limit exceeded')
      end
    end
  end

end
