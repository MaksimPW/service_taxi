class Inspection

  # Принадлежит/лежит ли точка в/на окружности?
  # x1, y1 - координаты точки
  # x2, y2, r - координаты центра окружности и ее радиуса

  def self.inside_the_circle?(x1,y1,x2,y2,r)
    return true if (((x1 - x2)**2) + ((y1 - y2)**2)) <= r**2
    false
  end
end
