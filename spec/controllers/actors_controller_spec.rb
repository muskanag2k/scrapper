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
  end

end
