class Api::V1::ApiWaybillsController <  Api::V1::ApplicationController
  def ping
    render json: {version: 'v1', access: 'true' }
  end
end