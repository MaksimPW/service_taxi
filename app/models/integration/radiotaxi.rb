class Integration::Radiotaxi
  def self.load_cars
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
  end

  def self.load_drivers
    sql = "SELECT zip, fam_long, dop_info, pozv FROM PERSONEL;"
    cursor = Integration::RadiotaxiDb.connection.execute(sql)

    h = Hash.new { |h, k| h[k] = Hash.new { |hh, kk| hh[kk] = {} } }
    @i = 0

    while row = cursor.fetch(:hash)
      break if row['NAME'] =~ /e 13/
      h[@i]['id'] = row['zip']
      h[@i]['fio'] = row['fam_long']
      h[@i]['description'] = row['dop_info']
      h[@i]['alias'] = row['pozv']
      @i+=1
    end

    cursor.close

    h.each do |index, key|
      if driver = Driver.find_by_id(key['id'].to_i)
        driver.update!(fio: key['fio'], description: key['description'], alias: key['alias'])
      else
        Driver.create!(fio: key['fio'], description: key['description'], alias: key['alias'])
      end
    end
  end

  def self.load_orders(take_date)
    sql = "SELECT * FROM ZAKAS WHERE time_ready LIKE '%#{take_date}%';"
    cursor = Integration::RadiotaxiDb.connection.execute(sql)

    h = Hash.new { |h, k| h[k] = Hash.new { |hh, kk| hh[kk] = {} } }
    @i = 0

    while row = cursor.fetch(:hash)
      break if row['NAME'] =~ /e 13/
      h[@i]['id'] = row['zip']
      h[@i]['car_id'] = row['zip_avto']
      h[@i]['driver_id'] = row['zip_vod']
      #h[@i]['status_buy'] = row['zip_avto']
      h[@i]['operator'] = row['fio_spr']
      h[@i]['take_time'] = row['time_zak']
      h[@i]['begin_time'] = row['time_vod']
      h[@i]['end_time'] = row['time_kon']
      h[@i]['begin_address'] = row['adr_call']
      h[@i]['end_address'] = row['adr_nazn']
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
            car_id: key['car_id'],
            driver_id: key['driver_id'],
            operator: key['operator'],
            take_time: key['take_time'],
            begin_time: key['begin_time'],
            end_time: key['end_time'],
            begin_address: key['begin_address'],
            end_address: key['end_address'],
            cost: key['cost'],
            distance: key['distance'],
        )
      else
        p 'create'
        Order.create!(
            id: key['id'],
            car_id: key['car_id'],
            driver_id: key['driver_id'],
            operator: key['operator'],
            take_time: key['take_time'],
            begin_time: key['begin_time'],
            end_time: key['end_time'],
            begin_address: key['begin_address'],
            end_address: key['end_address'],
            cost: key['cost'],
            distance: key['distance'],
        )
      end
    end
  end
end
