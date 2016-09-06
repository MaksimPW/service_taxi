class Integration::GeoritmController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'

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

  def index
    @api_path = '/restapi/objects/obj-search/json'

    @body_json ={
        objType: 0
    }.to_json

    @response = post_api(@api_path, @body_json)
    render json: @response

    # 1 Пользователь авторизуется(запоминаются данные Auth Basic в сессии)
    # 2 Программа получает параметры (speed, licenseNumber, SIM и тд.)
    # 3 Программа сохраняет эти параметры в базе данных (у каждого car должен быть свой список состояний)
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
