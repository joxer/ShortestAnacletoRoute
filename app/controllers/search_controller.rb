class SearchController < ApplicationController
  def search_route

    render :inline => "#{params[:start_path]} #{params[:end_path]}"
    
  end
end
