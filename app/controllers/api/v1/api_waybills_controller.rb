class Api::V1::ApiWaybillsController < Api::V1::BaseController
  def ping
    render json: { version: 'v1', access: 'true', time: "#{Time.now}" }
  end

  def create
    respond_with(@waybill = Waybill.create(waybill_params), location: false)
  end

  def update
    @waybill = Waybill.find_by_waybill_id(params[:id])
    render json: @waybill if @waybill.update(waybill_params)
  end

  private

  def waybill_params
    params.require(:waybill).permit(
        :waybill_id,
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