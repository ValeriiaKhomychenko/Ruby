require_relative 'ship'
require_relative 'errors'

class Board
  attr_reader :grid, :ships

  def initialize
    # Сітка 10х10. '.' - порожньо, 'S' - корабель, 'X' - влучання, '*' - промах
    @grid = Array.new(10) { Array.new(10, '.') }
    @ships = []
    @shots = [] # Зберігаємо всі координати пострілів, щоб уникнути повторів
  end

  def place_ships_randomly
    # Стандартний набір кораблів для Морського бою
    sizes = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1]

    sizes.each do |size|
      placed = false
      until placed
        r = rand(10)
        c = rand(10)
        horizontal = [true, false].sample
        coords = []

        size.times do |i|
          coords << (horizontal ? [r, c + i] : [r + i, c])
        end

        # Якщо розміщення валідне, ставимо корабель
        if valid_placement?(coords)
          @ships << Ship.new(coords)
          coords.each { |cr, cc| @grid[cr][cc] = 'S' }
          placed = true
        end
      end
    end
  end

  def valid_placement?(coords)
    coords.each do |r, c|
      # Перевірка виходу за межі поля
      return false if r < 0 || r > 9 || c < 0 || c > 9

      # Перевірка, чи не торкається іншого корабля (навіть по діагоналі)
      (-1..1).each do |dr|
        (-1..1).each do |dc|
          nr, nc = r + dr, c + dc
          next if nr < 0 || nr > 9 || nc < 0 || nc > 9 # Ігноруємо клітинки за межами поля
          return false if @grid[nr][nc] == 'S'
        end
      end
    end
    true
  end

  def receive_shot(r, c)
    raise InvalidCoordinateError, "Координати за межами поля!" if r < 0 || r > 9 || c < 0 || c > 9
    raise RepeatedShotError, "Ви вже стріляли в цю клітинку!" if @shots.include?([r, c])

    @shots << [r, c]
    target_ship = @ships.find { |s| s.covers?(r, c) }

    if target_ship
      target_ship.hit!
      @grid[r][c] = 'X'
      return target_ship.sunk? ? :sunk : :hit
    else
      @grid[r][c] = '*'
      return :miss
    end
  end

  def all_sunk?
    @ships.all?(&:sunk?)
  end

  def print_board(hide_ships: false)
    print "   "
    (1..10).each { |i| print "#{i.to_s.ljust(2)} " }
    puts

    @grid.each_with_index do |row, r|
      row_label = (r + 65).chr # Перетворення 0..9 на A..J
      print "#{row_label}  "
      row.each do |cell|
        char = (hide_ships && cell == 'S') ? '.' : cell
        print "#{char}  "
      end
      puts
    end
  end
end