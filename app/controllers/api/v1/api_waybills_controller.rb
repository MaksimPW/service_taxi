class Api::V1::ApiWaybillsController <  Api::V1::ApplicationController
  def ping
    render json: { version: 'v1', access: 'true', time: "#{Time.now}" }
  end

  def create
    @waybill = Waybill.new(strong_params)
    if @waybill.save
      render json: { action: 'create', status: 'success', time: "#{Time.now}" }
    else
      render json: { action: 'create', status: 'invalid', time: "#{Time.now}" }
    end
  end

  private

  def strong_params
    params.require(:waybill).permit(
        :waybill_number,
        :car_number,
        :creator,
        :driver_alias,
        :fio,
        :created_waybill_at,
        :begin_road_at,
        :end_road_at
    )
  end
end