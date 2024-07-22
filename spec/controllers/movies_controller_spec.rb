require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe 'GET #show' do
    it 'fetches and render top N movies' do
      get :show, params: { id: 4 }
      puts JSON.parse(response.body)
    end
  end
end



#specs
#coverage report simplecov
