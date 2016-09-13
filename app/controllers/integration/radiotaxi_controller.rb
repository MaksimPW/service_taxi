class Integration::RadiotaxiController < ApplicationController
  before_action :connect_db

  def cars
    sql = "SELECT zip, marka, nomer, zip_vod FROM AVTO;"
    cursor = ActiveRecord::Base.connection.execute(sql)

    h = Hash.new
    i = 0

    while row = cursor.fetch(:hash)
      break if row['NAME'] =~ /e 13/

      h[i]['id'] = row['zip']
      h[i]['mark'] = row['marka']
      h[i]['license_number'] = row['nomer']
      h[i]['driver_id'] = row['zip_vod']
      i+=1
    end

    cursor.close
    ActiveRecord::Base.remove_connection
    ActiveRecord::Base.establish_connection

    h.each do |h|
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
    render nothing: true
  end

  def drivers
    sql = "SELECT zip, fam_long, dop_info FROM PERSONEL;"
    cursor = ActiveRecord::Base.connection.execute(sql)

    h = Hash.new
    i = 0

    while row = cursor.fetch(:hash)
      break if row['NAME'] =~ /e 13/
      h = Hash.new
      h['id'] = row['zip']
      h['fio'] = row['fam_long']
      h['description'] = row['dop_info']
      i+=1
    end

    cursor.close
    ActiveRecord::Base.remove_connection
    ActiveRecord::Base.establish_connection

    h.each do |h|
      if driver = Driver.where(id: h['id'])
        driver.save!(fio: h['fio'], description: h['description'])
      else
        Driver.create!(fio: h['fio'], description: h['description'])
      end
    end
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