def slice_cake(cake_str)
  grid = cake_str.strip.split("\n").map { |row| row.strip.chars }
  h = grid.size
  w = grid[0].size

  raisins = []
  h.times do |r|
    w.times do |c|
      raisins << [r, c] if grid[r][c] == 'o' || grid[r][c] == 'о'
    end
  end

  n = raisins.size
  return [] if n == 0 || (h * w) % n != 0

  target_area = (h * w) / n

  possible_shapes = []
  (1..target_area).each do |dh|
    if target_area % dh == 0
      dw = target_area / dh
      possible_shapes << [dh, dw]
    end
  end

  all_solutions = []
  visited = Array.new(h) { Array.new(w, false) }

  solve = lambda do |current_pieces|
    start_r = nil
    start_c = nil

    h.times do |r|
      w.times do |c|
        unless visited[r][c]
          start_r = r
          start_c = c
          break
        end
      end
      break if start_r
    end

    if start_r.nil?
      all_solutions << current_pieces.dup
      return
    end

    possible_shapes.each do |dh, dw|
      end_r = start_r + dh
      end_c = start_c + dw

      next if end_r > h || end_c > w

      can_place = true
      (start_r...end_r).each do |r|
        (start_c...end_c).each do |c|
          if visited[r][c]
            can_place = false
            break
          end
        end
        break unless can_place
      end

      next unless can_place

      raisin_count = 0
      (start_r...end_r).each do |r|
        (start_c...end_c).each do |c|
          ch = grid[r][c]
          raisin_count += 1 if ch == 'o' || ch == 'о'
        end
      end

      next if raisin_count != 1

      (start_r...end_r).each do |r|
        (start_c...end_c).each do |c|
          visited[r][c] = true
        end
      end

      piece_lines = (start_r...end_r).map do |r|
        grid[r][start_c...end_c].join
      end

      solve.call(current_pieces + [piece_lines])

      (start_r...end_r).each do |r|
        (start_c...end_c).each do |c|
          visited[r][c] = false
        end
      end
    end
  end

  solve.call([])

  return [] if all_solutions.empty?

  best_solution = all_solutions.max_by do |solution|
    solution[0][0].length
  end

  best_solution
end

# --- ТЕСТУВАННЯ ---

cake1 = <<~CAKE
  .o......
  ......o.
  ....o...
  ..o.....
CAKE

puts "--- Приклад 1 ---"
result1 = slice_cake(cake1)
result1.each_with_index do |piece, i|
  puts "Шматок #{i + 1}"
  puts piece
end

cake2 = <<~CAKE
  .o.o....
  ........
  ....o...
  ........
  .....o..
  ........
CAKE

puts "\n--- Приклад 2 ---"
result2 = slice_cake(cake2)
result2.each_with_index do |piece, i|
  puts "Шматок #{i + 1}"
  puts piece
end

