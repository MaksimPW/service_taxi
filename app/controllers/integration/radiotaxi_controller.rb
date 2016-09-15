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
      if car = Car.find_by_id(key['id'].to_i)
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
      if driver = Driver.find_by_id(key['id'].to_i)
        driver.update!(fio: key['fio'], description: key['description'])
      else
        Driver.create!(fio: key['fio'], description: key['description'])
      end
    end
    render nothing: true
  end

  def orders
    sql = "SELECT * FROM ZAKAS WHERE data LIKE '%#{params[:take_date]}%';"
    cursor = Integration::RadiotaxiDb.connection.execute(sql)

    h = Hash.new { |h, k| h[k] = Hash.new { |hh, kk| hh[kk] = {} } }
    @i = 0

    while row = cursor.fetch(:hash)
      break if row['NAME'] =~ /e 13/
      h[@i]['id'] = row['zip']
      h[@i]['car_id'] = row['zip_avto']
      h[@i]['driver_id'] = row['zip_avto']
      #h[@i]['status_buy'] = row['zip_avto']
      h[@i]['operator'] = row['fio_spr']
      h[@i]['take_time'] = row['time_zak']
      h[@i]['begin_time'] = row['time_vod']
      h[@i]['end_time'] = row['time_kon']
      h[@i]['begin_address_name'] = row['adr_call']
      h[@i]['end_address_name'] = row['adr_nazn']
      #h[@i]['begin_geo'] = row['zip_avto']
      #h[@i]['end_geo'] = row['dop_info']
      h[@i]['cost'] = row['stoim']
      h[@i]['distance'] = row['probeg']
      #h[@i]['description'] = row['zip_avto']
      @i+=1
    end

    cursor.close

    h.each do |index, key|
      if order = Order.find_by_id(key['id'].to_i)
        p 'update'
        order.update!(
            car_id: key['mark'],
            driver_id: key['license_number'],
            #status_buy
            operator: key['driver_id'],
            take_time: key['take_time'],
            begin_time: key['begin_time'],
            end_time: key['end_time'],
            begin_address_name: key['begin_address_name'],
            end_address_name: key['end_address_name'],
            #begin_geo
            #end_geo
            cost: key['cost'],
            distance: key['distance'],
            #description
        )
      else
        p 'create'
        Order.create!(
            id: key['id'],
            car_id: key['mark'],
            driver_id: key['license_number'],
            #status_buy
            operator: key['driver_id'],
            take_time: key['take_time'],
            begin_time: key['begin_time'],
            end_time: key['end_time'],
            begin_address_name: key['begin_address_name'],
            end_address_name: key['end_address_name'],
            #begin_geo
            #end_geo
            cost: key['cost'],
            distance: key['distance'],
            #description
        )
      end
    end
    render nothing: true
  end
end