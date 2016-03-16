class SearchController < ApplicationController

  before_filter :escape_parameters

  def search_route
    record = Route.where(start:  params[:start_path], end:  params[:end_path] ).first

    if record == nil
      new_route, routes = Rome2Rio::Tool.get_result(params[:start_path],params[:end_path])
      if new_route != nil
          r2r_class = Rome2Rio::Tool.save_to_DB(new_route,routes)
          render :json => r2r_class.to_json
      else
        render :json => {}
      end

    else
      render :json => record.to_json
    end
  end

  def home
  end

private
    def escape_parameters
      #escape parameters before putting them into application!

      params.each do |key,value|
        params[key] = CGI::escape_html(value)
      end
    end
end
