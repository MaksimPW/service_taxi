class Integration::RadiotaxiController < ApplicationController
  def init
    ActiveRecord::Base.establish_connection(
        adapter: 'fb',
        database: Rails.application.secrets.integration_radiotaxi_path,
        username: Rails.application.secrets.integration_radiotaxi_login,
        password: Rails.application.secrets.integration_radiotaxi_password,
        host: Rails.application.secrets.integration_radiotaxi_host,
    )
    sql = "SELECT * FROM RDB$RELATIONS;"
    cursor = ActiveRecord::Base.connection.execute(sql)

    i = 0
    while row = cursor.fetch(:hash)
      result[i] = row
      i+=1
      break if row['NAME'] =~ /e 13/
    end
    cursor.close

    render nothing: true
  end

  def execute

  end
end