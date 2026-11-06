class Ship
  attr_reader :coords, :size

  def initialize(coords)
    @coords = coords # Масив координат, наприклад: [[0, 0], [0, 1]]
    @size = coords.size
    @hits = 0
  end

  # Фіксуємо влучання
  def hit!
    @hits += 1
  end

  # Корабель знищено, якщо кількість влучань дорівнює його розміру
  def sunk?
    @hits == @size
  end

  # Перевіряє, чи знаходиться корабель за заданими координатами
  def covers?(r, c)
    @coords.include?([r, c])
  end
end