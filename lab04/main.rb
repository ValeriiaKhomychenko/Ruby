require_relative 'game'

# Вирішуємо проблему з кирилицею у консолі Windows
$stdin.set_encoding("UTF-8") if $stdin.respond_to?(:set_encoding)

class SeaBattleApp
  def initialize
    @wins = 0
    @losses = 0
  end

  def run
    loop do
      show_menu
      choice = gets.to_s.strip

      case choice
      when '1'
        start_game
      when '2'
        show_rules
      when '3'
        puts "\nДякуємо за гру! Ваша фінальна статистика:"
        show_stats
        break
      else
        puts "Неправильний вибір, введіть цифру від 1 до 3."
      end
    end
  end

  private

  def show_menu
    puts "\n" + "*"*30
    puts "         МОРСЬКИЙ БІЙ"
    puts "*"*30
    puts "1. Почати нову гру"
    puts "2. Правила гри"
    puts "3. Вихід"
    show_stats
    print "Оберіть дію (1-3): "
  end

  def show_stats
    puts "[ Статистика: Перемоги - #{@wins} | Поразки - #{@losses} ]"
  end

  def start_game
    game = Game.new
    result = game.play

    if result == :player_win
      puts "\nВІТАЄМО! ВИ ЗНИЩИЛИ ВСІ КОРАБЛІ КОМП'ЮТЕРА!"
      @wins += 1
    else
      puts "\nНА ЖАЛЬ, КОМП'ЮТЕР ЗНИЩИВ ВСІ ВАШІ КОРАБЛІ."
      @losses += 1
    end
  end

  def show_rules
    puts "\n--- ПРАВИЛА ГРИ ---"
    puts "1. Поле має розмір 10х10 (від A до J, від 1 до 10)."
    puts "2. Кораблі розміщуються автоматично і не торкаються одне одного."
    puts "3. Ви вводите координати пострілу (наприклад, A1, B5, J10)."
    puts "4. Позначення на полі:"
    puts "   . - невідома або порожня клітинка"
    puts "   S - ваш корабель"
    puts "   X - влучання в корабель"
    puts "   * - промах (постріл у воду)"
    puts "5. Перемагає той, хто першим знищить усі 10 кораблів супротивника."
  end
end

# Запуск програми
app = SeaBattleApp.new
app.run# frozen_string_literal: true

