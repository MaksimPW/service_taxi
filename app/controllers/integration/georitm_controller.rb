class Integration::GeoritmController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'

  def ping
    render json: post_api('/restapi/ping/json', '')
  end

  def init
    @api_path = '/restapi/users/login/json'

    @body_json ={
        login: "#{Rails.application.secrets.integration_georitm_login}",
        password: "#{Rails.application.secrets.integration_georitm_password}",
    }.to_json

    @response = post_api(@api_path, @body_json)
    @response = JSON.parse(@response)
    session[:integration_georitm_basic_auth] = @response["basic"]
    render json: @response
  end

  def execute
    @api_path = '/restapi/objects/obj-search/json'

    @body_json ={
        objType: 0
    }.to_json

    @response = post_api(@api_path, @body_json)

    @statuses = JSON.parse(@response)

    if session[:integration_georitm_basic_auth]
      @statuses.each do |st|
        StatusCar.create!(geo_lat: st["lat"],
                          geo_lon: st["lon"],
                          license_number: st["licenseNumber"],
                          speed: st["speed"],
                          fixed_time: st["lastPointDate"] || Time.now,
                          name: st["name"],
                          model: st["model"],
                          car_id: st["id"],
                          ext_id: st["extId"],
                          course: st["course"])
      end
    end

    render json: @response
  end

  private

  def post_api(api_path, body_json)
    req = Net::HTTP::Post.new(api_path, initheader = {'Content-Type' => 'application/json',
                                                      'Authorization' => "Basic #{session[:integration_georitm_basic_auth]}"
                                      })
    req.body = body_json
    response = Net::HTTP.new(Rails.application.secrets.integration_georitm_host,
                             Rails.application.secrets.integration_georitm_port).start {|http| http.request(req) }
    response.body
  end
end
