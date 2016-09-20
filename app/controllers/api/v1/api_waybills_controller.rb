class Api::V1::ApiWaybillsController < Api::V1::BaseController
  def ping
    render json: { version: 'v1', access: 'true', time: "#{Time.now}" }
  end

  def create
    @waybill = Waybill.new(waybill_params)
    if @waybill.save
      render json: @waybill
    else
      render json: { action: 'create', status: 'invalid', time: "#{Time.now}" }
    end
  end

  def update
    @waybill = Waybill.find(params[:id])
    @waybill.update(waybill_params)
    render json: @waybill
  end

  private

  def waybill_params
    params.require(:waybill).permit(
        :id,
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