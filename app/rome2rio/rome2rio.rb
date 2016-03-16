require 'net/http'
require 'uri'
require 'json'
module Rome2Rio
  class WebCall
    #Interface for the website

    @@mashape_key = "7gYkYKTqNimshnPyF5nEKlxPllg0p152znzjsnNWxK9znWFGgS"
    @@base_url = "https://rome2rio12.p.mashape.com"

    def self.get_from_a_to_b(a_point,b_point)
      do_request_from_a_to_b(a_point,b_point)
    end

    private
    def self.do_request_from_a_to_b(a_point, b_point)

      result = {}
      url = URI.parse(@@base_url)

      req = Net::HTTP::Get.new("/Search?oName=#{URI.escape(a_point)}&dName=#{URI.escape(b_point)}")
      req.add_field("X-Mashape-Key", @@mashape_key)
      req["accept"] = 'application/json'
      req["content-type"] = 'application/json'
      res = Net::HTTP.start(url.host, 443, :use_ssl => true) do |http|
        http.request(req)
      end

      begin
        result = JSON.parse(res.body)
      rescue Exception => e
        #  puts e.message
        #  puts e.backtrace.inspect
      end

      return result
    end
  end

  class Tool

    def self.get_result(point_a,point_b)

      res = WebCall.get_from_a_to_b(point_a,point_b)

      if res != {} && res != nil

        new_route = Route.new(start: point_a, end:point_b, full_start: res["places"][0].to_json, full_end: res["places"][1].to_json)


        routes = res["routes"].map do |route|
          duration = route["duration"].to_i
          type = self.get_type_of_route(route["name"])
          price = route["indicativePrice"]["price"].to_i

          {duration: duration ,type:type, price: price}
        end

        transports_media = self.calculate_media(routes)
        new_route.cache = JSON.generate(transports_media)

        return new_route, routes
      else
        return nil, []
      end
    end

    def self.get_result_and_save_to_DB(point_a,point_b)
      new_route, routes = self.get_result(point_a, point_b)
      self.save_to_DB(new_route,routes)
      new_route
    end
    def self.save_to_DB(new_route, routes)
      begin
        if(new_route != nil)
          new_route.save!
          routes.each do |route|
            new_route.route_transports << RouteTransport.create!(route_type: route[:type], price: route[:price],duration: route[:duration], route_id: new_route.id)
          end
        end
      rescue Exception => e
        puts e.message
        puts e.backtrace.join("\n")
      end

      return new_route
    end

    def self.get_type_of_route(route)
      if route =~ /fly/i
        return :plane
      elsif route =~ /train/i
        return :train
      elsif route =~ /bus/i
        return :bus
      else
        return :else
      end
    end


    def self.calculate_media(routes)
      transports = {}
      routes.each do |route|
        type = route[:type]
        if(type != :else)
          if(transports[type] != nil)
            transports[type][:price] << route[:price]
            transports[type][:duration] << route[:duration]
          else
            transports[type] = {price:  [route[:price]], duration: [route[:duration]]}
          end
        end
      end


      transports.each do |key, transport|
        duration_avg = transport[:duration].inject(:+)/transport[:duration].length
        price_avg = transport[:price].inject(:+)/transport[:price].length

        transport[:duration] = duration_avg
        transport[:price] = price_avg
      end
      transports
    end
    
  end
end
