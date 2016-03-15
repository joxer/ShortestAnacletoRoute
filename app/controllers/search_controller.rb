class SearchController < ApplicationController
  def search_route
    render :json => Rome2Rio.get_from_a_to_b(params[:start_path],params[:end_path]).to_json
  end

  def home


  end
end
