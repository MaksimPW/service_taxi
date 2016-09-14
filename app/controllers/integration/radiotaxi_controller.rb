class Integration::RadiotaxiController < ApplicationController

  def cars
    sql = "SELECT zip, marka, nomer, zip_vod FROM AVTO;"
    cursor = Integration::RadiotaxiDb.connection.execute(sql)

    h = Hash.new { |h, k| h[k] = Hash.new { |hh, kk| hh[kk] = {} } }
    @i = 0

    while row = cursor.fetch(:hash)
      break if row['NAME'] =~ /e 13/
      h[@i]['id'] = row['zip']
      h[@i]['mark'] = row['marka']
      h[@i]['license_number'] = row['nomer']
      h[@i]['driver_id'] = row['zip_vod']
      @i+=1
    end

    cursor.close

    h.each do |index, key|
      if car = Car.find_by(key['id'])
        car.update!(
            mark: key['mark'],
            license_number: key['license_number'],
            driver_id: key['driver_id']
        )
      else
        Car.create!(
            id: key['id'],
            mark: key['mark'],
            license_number: key['license_number'],
            driver_id: key['driver_id']
        )
      end
    end
    render nothing: true
  end

  def drivers
    sql = "SELECT zip, fam_long, dop_info FROM PERSONEL;"
    cursor = Integration::RadiotaxiDb.connection.execute(sql)

    h = Hash.new { |h, k| h[k] = Hash.new { |hh, kk| hh[kk] = {} } }
    @i = 0

    while row = cursor.fetch(:hash)
      break if row['NAME'] =~ /e 13/
      h[@i]['id'] = row['zip']
      h[@i]['fio'] = row['fam_long']
      h[@i]['description'] = row['dop_info']
      @i+=1
    end

    cursor.close

    h.each do |index, key|
      if driver = Driver.find_by(key['id'])
        driver.update!(fio: key['fio'], description: key['description'])
      else
        Driver.create!(fio: key['fio'], description: key['description'])
      end
    end
    render nothing: true
  end
end