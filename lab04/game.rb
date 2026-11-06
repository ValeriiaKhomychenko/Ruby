require_relative 'board'
require_relative 'errors'

class Game
  def initialize
    @player_board = Board.new
    @computer_board = Board.new
    # Усі можливі ходи для комп'ютера. Змішуємо масив, щоб він стріляв випадково без повторів.
    @computer_moves = (0..9).to_a.product((0..9).to_a).shuffle
  end

  def play
    @player_board.place_ships_randomly
    @computer_board.place_ships_randomly

    loop do
      puts "\n" + "="*30
      puts "--- ВАШЕ ПОЛЕ ---"
      @player_board.print_board(hide_ships: false)
      puts "\n--- ПОЛЕ КОМП'ЮТЕРА ---"
      @computer_board.print_board(hide_ships: true)
      puts "="*30

      player_turn
      return :player_win if @computer_board.all_sunk?

      computer_turn
      return :computer_win if @player_board.all_sunk?
    end
  end

  private

  def player_turn
    loop do
      print "\nВаш хід (наприклад, A1, J10): "
      input = gets.to_s.strip.upcase

      begin
        r, c = parse_input(input)
        result = @computer_board.receive_shot(r, c)
        announce_result("Ви", result)
        break # Якщо постріл успішний, виходимо з циклу запиту
      rescue InvalidCoordinateError, RepeatedShotError => e
        puts "Помилка: #{e.message}. Спробуйте ще раз."
      end
    end
  end

  def computer_turn
    r, c = @computer_moves.pop # Беремо останній елемент з перемішаного списку
    result = @player_board.receive_shot(r, c)

    row_label = (r + 65).chr
    col_label = c + 1
    puts "\nКомп'ютер стріляє в #{row_label}#{col_label}!"
    announce_result("Комп'ютер", result)
  end

  def parse_input(input)
    # Перевірка формату за допомогою регулярного виразу
    unless input.match?(/\A[A-J]([1-9]|10)\z/)
      raise InvalidCoordinateError, "Неправильний формат вводу. Використовуйте літери A-J та цифри 1-10 (наприклад, B4)."
    end

    r = input[0].ord - 65
    c = input[1..-1].to_i - 1
    [r, c]
  end

  def announce_result(shooter, result)
    case result
    when :miss
      puts "=> #{shooter} промахнувся(лись) повз ціль!"
    when :hit
      puts "=> #{shooter} влучив(ли) у корабель!"
    when :sunk
      puts "=> #{shooter} ПОВНІСТЮ ЗНИЩИВ(ЛИ) корабель!"
    end
  end
end