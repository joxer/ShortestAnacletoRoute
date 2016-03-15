class SearchController < ApplicationController
  def search_route
    record = Route.where(start:  params[:start_path], end:  params[:end_path] ).first
    
    if record == nil
      result = Rome2Rio.get_from_a_to_b(params[:start_path],params[:end_path]).to_json
      Route.create(start: params[:start_path], end: params[:end_path], cache: result ,delta: DateTime.now)
      render :json => result
    else
      render :json => record.cache
    end
  end

  def home


  end
end
