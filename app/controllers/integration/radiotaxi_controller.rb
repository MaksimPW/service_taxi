class Integration::RadiotaxiController < ApplicationController
  before_action :connect_db

  def cars
    sql = "SELECT zip, marka, nomer, zip_vod FROM AVTO;"
    cursor = ActiveRecord::Base.connection.execute(sql)

    while row = cursor.fetch(:hash)
      break if row['NAME'] =~ /e 13/

      h = Hash.new
      h['id'] = row['zip']
      h['mark'] = row['marka']
      h['license_number'] = row['nomer']
      h['driver_id'] = row['zip_vod']

      if car = Car.where(id: h['id'])
        car.save!(
            mark: h['mark'],
            license_number: h['license_number'],
            driver_id: h['driver_id']
        )
      else
        Car.create!(
            id: h['id'],
            mark: h['mark'],
            license_number: h['license_number'],
            driver_id: h['driver_id']
        )
      end
    end

    cursor.close
    render nothing: true
  end

  def drivers
    sql = "SELECT zip, fam_long, dop_info FROM PERSONEL;"
    cursor = ActiveRecord::Base.connection.execute(sql)

    while row = cursor.fetch(:hash)
      break if row['NAME'] =~ /e 13/

      h = Hash.new
      h['id'] = row['zip']
      h['fio'] = row['fam_long']
      h['description'] = row['dop_info']

      if driver = Driver.where(id: h['id'])
        driver.save!(fio: h['fio'], description: h['description'])
      else
        Driver.create!(fio: h['fio'], description: h['description'])
      end
    end

    cursor.close
    render nothing: true
  end

  private

  def connect_db
    ActiveRecord::Base.establish_connection(
        adapter: 'fb',
        database: Rails.application.secrets.integration_radiotaxi_path,
        username: Rails.application.secrets.integration_radiotaxi_login,
        password: Rails.application.secrets.integration_radiotaxi_password,
        host: Rails.application.secrets.integration_radiotaxi_host,
        encoding: 'cp1251'
    )
  end
end