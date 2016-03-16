class SearchPlaceJob < ApplicationJob
  queue_as :default

  def perform(id, point_a, point_b)
    begin
    new_route, routes = Rome2Rio::Tool.get_result(point_a, point_b)

    if new_route != nil
        r2r_class = Rome2Rio::Tool.save_to_DB(new_route,routes)
        RouteJob.create(job_id: id, result: true, route_id: r2r_class.id)
    else
      RouteJob.create(job_id: id, result: false)
    end

  rescue Exception => e
    p e
  end
  end
end
