require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe 'GET #show' do
    it 'fetches and render top N movies' do
      get :show, params: { id: 4 }, format: :json  # Specify format as JSON
      json_response = JSON.parse(response.body)
      puts json_response
    end
  end
end
