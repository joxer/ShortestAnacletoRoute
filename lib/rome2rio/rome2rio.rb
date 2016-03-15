require 'net/http'
require 'uri'
require 'json'

class Rome2Rio
  #Interface for the website

  @@mashape_key = "7gYkYKTqNimshnPyF5nEKlxPllg0p152znzjsnNWxK9znWFGgS"
  @@base_url = "https://rome2rio12.p.mashape.com"

  def self.get_from_a_to_b(a_point,b_point)
    res = do_request_from_a_to_b(a_point,b_point)
    return Rome2Rio.parse_result(res)
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

    result
  end

  def self.parse_result(json)

    if(json != {})
      result = Rome2RioResult.new

      point_a = json['places'][0]
      point_b = json['places'][1]



      result.start = point_a
      result.end = point_b

      routes = json['routes'].map  do |route|
        travel_way = self.getTravelRoute(route['name'])


        if (travel_way == :flight || travel_way == :bus || travel_way == :train)
        result.add_transport(
        travel_way,
        route['duration'].to_i,
        route['indicativePrice']['price'].to_i
        )
        end

      end
    else
      result = Rome2RioResult::Dummy.new
    end

    return result
  end

  def self.getTravelRoute(name)

    if name =~ /Fly/
      :flight
    elsif name =~ /Bus/
      :bus
    elsif name =~ /Train/
      :train
    end
  end
end



class Rome2RioResult

  class Dummy < Rome2RioResult
  end

  attr_accessor :start, :end, :transports
  def initialize(start=nil,pend=nil,transports={})
    @start,@end = start,pend
    @transports = transports
  end

  def add_transport(kind, duration, price)

    if(@transports[kind] == nil)
      @transports[kind] = { duration: duration, price: price}
    else

      @transports[kind][:duration] = (@transports[kind][:duration]+duration)/2 # or 2.0 ?
      @transports[kind][:price] = (@transports[kind][:price]+price)/2 # or 2.0 ?
    end
  end

  def empty?
    if(@start == nil || @end == nil)
      true
    else
      false
    end
  end

  def to_s
    "#{@start} - #{@end} "
  end
end
