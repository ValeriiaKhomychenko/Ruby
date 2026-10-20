class Sudoku
  def initialize
    # 0 = порожня клітинка
    @initial_board = [
      [1, 0, 0, 4],
      [0, 4, 1, 0],
      [0, 1, 4, 0],
      [4, 0, 0, 1]
    ]

    @board = @initial_board.map(&:dup)
  end

  def play
    $stdin.set_encoding("UTF-8") if $stdin.respond_to?(:set_encoding)

    puts "--- Гра Судоку 4x4 ---"
    puts "Заповніть порожні клітинки (.) числами від 1 до 4."

    loop do
      print_board

      if win?
        puts "\nВітаємо! Ви успішно та правильно розв'язали Судоку!"
        break
      end

      print "\nВведіть РЯДОК, СТОВПЕЦЬ і ЧИСЛО через пробіл (наприклад: 1 2 3) або 'вихід' (чи 0): "

      raw_input = gets.to_s
      input = raw_input.encode('UTF-8', invalid: :replace, undef: :replace).strip.downcase


      break if input == 'вихід' || input == 'exit' || input == '0'

      parts = input.split

      if parts.size != 3
        puts "Помилка: Потрібно ввести рівно 3 значення (або слово 'вихід')!"
        next
      end

      row = parts[0].to_i - 1
      col = parts[1].to_i - 1
      num = parts[2].to_i

      unless row.between?(0, 3) && col.between?(0, 3)
        puts "Помилка: Рядок і стовпець мають бути від 1 до 4."
        next
      end

      unless num.between?(0, 4)
        puts "Помилка: Число має бути від 1 до 4 (або 0 для очищення клітинки)."
        next
      end

      if @initial_board[row][col] != 0
        puts "Помилка: Це початкове число, його змінювати заборонено!"
        next
      end

      if num == 0
        @board[row][col] = 0
        puts "Клітинку очищено."
        next
      end

      if valid_move?(row, col, num)
        @board[row][col] = num
        puts "Хід прийнято!"
      else
        puts "Помилка: Таке число вже є в цьому рядку, стовпці або блоці 2x2!"
      end
    end

    puts "Гру завершено."
  end

  private

  def print_board
    puts "\n    1 2   3 4  (Стовпці)"
    puts "  +-------+-------+"

    @board.each_with_index do |row_array, r_idx|
      print "#{r_idx + 1} | "

      row_array.each_with_index do |cell, c_idx|
        print cell == 0 ? ". " : "#{cell} "

        print "| " if c_idx == 1 || c_idx == 3
      end

      puts

      puts "  +-------+-------+" if r_idx == 1 || r_idx == 3
    end
  end

  def valid_move?(row, col, num)
    4.times do |c|
      return false if @board[row][c] == num && c != col
    end

    4.times do |r|
      return false if @board[r][col] == num && r != row
    end

    start_row = (row / 2) * 2
    start_col = (col / 2) * 2

    (start_row...start_row + 2).each do |r|
      (start_col...start_col + 2).each do |c|
        return false if @board[r][c] == num && (r != row || c != col)
      end
    end

    true
  end

  def win?

    @board.flatten.none? { |cell| cell == 0 }
  end
end

Sudoku.new.play
