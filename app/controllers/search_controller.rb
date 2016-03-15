class SearchController < ApplicationController
  def search_route

    render :inline => Rome2Rio.get_from_a_to_b(params[:start_path],[:end_path]).to_s

  end
end
