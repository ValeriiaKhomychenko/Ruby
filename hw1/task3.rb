def play_rps
  options = {
    1 => "Камінь",
    2 => "Ножиці",
    3 => "Папір"
  }

  # Правила: хто кого перемагає
  # 1 (Камінь) б'є 2 (Ножиці)
  # 2 (Ножиці) б'ють 3 (Папір)
  # 3 (Папір)  б'є 1 (Камінь)
  winning_rules = {
    1 => 2,
    2 => 3,
    3 => 1
  }

  stats = {
    rounds: 0,
    user_wins: 0,
    computer_wins: 0,
    draws: 0
  }

  puts "=== Гра: Камінь, ножиці, папір ==="
  puts "Правила вводу: 1 — Камінь, 2 — Ножиці, 3 — Папір, 0 — Вихід\n\n"

  loop do
    puts "Твій вибір (1, 2, 3 або 0): "
    input = gets.chomp.strip

    break if input == "0"

    user_choice = input.to_i

    # Перевірка: чи число входить у діапазон від 1 до 3
    unless [1, 2, 3].include?(user_choice)
      puts "Некоректний вибір! Введи лише цифру: 1, 2 або 3 (або 0 для виходу).\n\n"
      next
    end

    computer_choice = rand(1..3)

    puts "Ти:        #{options[user_choice]}"
    puts "Комп'ютер: #{options[computer_choice]}"

    stats[:rounds] += 1

    # Визначаємо переможця за правилами
    if user_choice == computer_choice
      puts "Результат: Нічия!"
      stats[:draws] += 1
    elsif winning_rules[user_choice] == computer_choice
      puts "Результат: Ви перемогли!"
      stats[:user_wins] += 1
    else
      puts "Результат: Комп'ютер переміг!"
      stats[:computer_wins] += 1
    end

    # Виведення статистики
    puts "\n--- Статистика гри ---"
    puts "Раундів зіграно:    #{stats[:rounds]}"
    puts "Переміг гравець:     #{stats[:user_wins]}"
    puts "Переміг комп'ютер: #{stats[:computer_wins]}"
    puts "Нічиїх:             #{stats[:draws]}"
    puts "-----------------------\n\n"
  end

  puts "Гру завершено! Дякую за гру."
end

play_rps