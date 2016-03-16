class SearchController < ApplicationController

  before_filter :escape_parameters

  def search_route

    random_id = SecureRandom.hex(5)

    record = Route.where(start:  params[:start_path], end:  params[:end_path] ).first

    if record == nil
      SearchPlaceJob.perform_later(random_id, params[:start_path], params[:end_path])
      render :json => {result: "wait", message:"Wait for computation", id: random_id }
    else
      json_obj = record.to_h
      json_obj["result"] = "true"
      json_obj["message"] = "Found"
      render :json => json_obj.to_json
    end
  end


  def get_result
    job = RouteJob.where(job_id:  params[:id]).first
    if(job != nil)
      if(job.result == true)
        record = Route.where(id: job.route_id ).first
        json_obj = record.to_h
        json_obj["result"] = "true"
        json_obj["message"] = "Found"
        render :json => json_obj.to_json
      else
        render :json => {result: "false", message: "No data available"}
      end
    else
      render :json => {result: "wait", message: "loading"}
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
