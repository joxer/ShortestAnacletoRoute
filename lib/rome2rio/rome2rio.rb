require 'net/http'
require 'uri'
require 'json'

class Rome2Rio
  #Interface for the website

  def initialize
    @@mashape_key = "7gYkYKTqNimshnPyF5nEKlxPllg0p152znzjsnNWxK9znWFGgS"
    @@base_url = "https://rome2rio12.p.mashape.com"
  end

  def get_from_a_to_b(a_point,b_point)
    do_request_from_a_to_b(a_point,b_point)
    return Rome2Rio.parse_result(@cache)
  end

  def do_request_from_a_to_b(a_point, b_point)

    if @cache == nil
      url = URI.parse(@@base_url)

      req = Net::HTTP::Get.new("/Search?oName=#{a_point}&dName=#{b_point}")
      req.add_field("X-Mashape-Key", "7gYkYKTqNimshnPyF5nEKlxPllg0p152znzjsnNWxK9znWFGgS")
      req["accept"] = 'application/json'
      req["content-type"] = 'application/json'
      res = Net::HTTP.start(url.host, 443, :use_ssl => true) do |http|
        http.request(req)
      end
      begin
        @cache = JSON.parse(res.body)
      rescue
        @cache = {}
      end
    end

    @cache
  end

  def self.parse_result(json)

    if(json != {})
      result = Rome2RioResult.new

      point_a = json['places'][0]
      point_b = json['places'][1]

      result.start = point_a
      result.end = point_b

      routes = json['routes'].map  do |route|
        result.add_transport(
        route['segments'][0]['kind'].to_sym,
        route['duration'].to_i,
        route['indicativePrice']['price'].to_i
        )
      end
    else
      result = Rome2RioResult::Dummy.new
    end

    return result
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
    true if(@start == nil || @end == nil)
  end  
end
