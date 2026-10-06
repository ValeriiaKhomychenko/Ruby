def word_stats(text)
  words = text.downcase.scan(/\b[a-zA-Zа-яА-ЯіїєґІЇЄҐ0-9_'-]+\b/)
  return {total_words: 0, longest_word: nil , unique_words: 0} if words.empty?
  total_words = words.size
  longest_word = words.max_by(&:length)
  unique_words = words.uniq.size
  {
    total_words: total_words,
    longest_word: longest_word,
    unique_words: unique_words
  }
end

text = "Ruby is fun AND ruby is powerful"
stats = word_stats(text)

puts "#{stats[:total_words]} слів, найдовше: #{stats[:longest_word]}, унікальних: #{stats[:unique_words]}"