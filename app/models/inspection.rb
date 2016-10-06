class Inspection

  # Принадлежит/лежит ли точка в/на окружности?
  # x1, y1 - координаты точки
  # x2, y2, r - координаты центра окружности и ее радиуса

  def self.inside_the_circle?(x1,y1,x2,y2,r)
    return true if (((x1 - x2)**2) + ((y1 - y2)**2)) <= r**2
    false
  end

  def self.summary_build_route(locations)
    # Mapzen Turn-by-Turn routing service API reference
    # Limits and Documentation: https://mapzen.com/documentation/overview/
    mapzen_key = Rails.application.secrets.mapzen_key

    limit_locations = 20
    return false if locations.count > limit_locations

    @locations_json = Array.new
    @locations = Array.new

    locations.each do |id|
      @locations << StatusCar.find(id)
    end

    @locations.each do |l|
      @locations_json << {"lat": l.geo_lat, "lon": l.geo_lon}
    end

    respond_json = {locations: @locations_json,
             costing:'auto',
             costing_options:{auto:{country_crossing_penalty:2000.0}},
             directions_options:{units:'km'},id:'build_route'}

    response = RestClient.get 'http://valhalla.mapzen.com/route', {params: {json: respond_json.to_json, api_key: mapzen_key}}

    # Out
    parsed_body = JSON.parse(response.body)
    parsed_body["trip"]["legs"][0]["summary"]
  end
end
