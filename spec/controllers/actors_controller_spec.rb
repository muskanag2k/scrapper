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



# RSpec.describe ActorsController, type: :controller do
#   describe 'GET #show' do
#     context 'when actor exists and valid input' do
#       let(:valid_params) { { actor_name: "Morgan Freeman", input: 3 } }

#       before { get :show, params: valid_params }

#       it 'returns the correct actor name' do
#         json_response = JSON.parse(response.body)
#         # expect(json_response["actor"]).to eq(actor.name)
#       end

#       it 'returns the top movies with correct attributes' do
#         json_response = JSON.parse(response.body)
#         puts json_response
#         # expect(json_response["top_movies"].count).to eq(3)
#         # expect(json_response["top_movies"][0]["position"]).to eq(1)
#         # expect(json_response["top_movies"][0]["title"]).to eq(movies[0].title)
#       end
#     end

#     context 'when actor does not exist or wrong input' do
#       let(:invalid_params) { { actor_name: 'Nonexistent Actor', input: 5 } }

#       before { get :show, params: invalid_params }

#       it 'returns a not found status' do
#         expect(response).to have_http_status(:not_found)
#       end

#       it 'returns an error message if actor not found' do
#         json_response = JSON.parse(response.body)
#         expect(json_response["error"]).to eq('Actor not found or Wrong input!')
#       end
#     end
#   end
# end
