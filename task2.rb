def play_game
  secret_number = rand(1..100)
  attempts = 0

  puts "=== Гра: Вгадай число ==="
  puts "Я загадав число від 1 до 100. Спробуй відгадати!"

  loop do
    print "Введи свій варіант: "
    input = gets.chomp

    # перевірка
    unless input.match?(/^\d+$/)
      puts "Будь ласка, введи коректне ціле число!"
      next
    end

    guess = input.to_i
    attempts += 1

    if guess < secret_number
      puts "Більше!"
    elsif guess > secret_number
      puts "Менше!"
    else
      puts "Вгадано! Ти використав спроб: #{attempts}."
      break
    end
  end
end

# запуск гри:
play_game