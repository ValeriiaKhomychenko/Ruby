require 'csv'
require 'json'
require 'fileutils'

input_path = File.join(__dir__, 'data', 'contacts.csv')

# якщо вхідного файла немає — warn і код завершення 1
unless File.exist?(input_path)
  warn "Помилка: вхідний файл не знайдено за шляхом #{input_path}"
  exit(1)
end

valid_contacts = []
error_rows = []

# простий регулярний вираз для перевірки всього рядка (\A...\z)
EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/

# читає CSV з заголовками (шлях від __dir__)
CSV.foreach(input_path, headers: true, encoding: 'UTF-8').with_index(1) do |row, row_number|
  name = row['name'].to_s.strip
  email = row['email'].to_s.strip

  # перевірка кожного запису
  if name.empty?
    error_rows << [row_number, 'Порожнє імʼя (name)']
  elsif !email.match?(EMAIL_REGEX)
    error_rows << [row_number, "Некоректний формат email: '#{email}'"]
  else
    # нормалізація коректних записів (ключі — рядки)
    valid_contacts << {
      'name' => name,
      'email' => email.downcase
    }
  end
end

output_dir = File.join(__dir__, 'output')
FileUtils.mkdir_p(output_dir)

# збереження коректних записів у output/contacts.json
contacts_json_path = File.join(output_dir, 'contacts.json')
File.write(contacts_json_path, JSON.pretty_generate(valid_contacts), encoding: 'UTF-8')

# запис некоректних записів у output/errors.csv з колонками row,reason
errors_csv_path = File.join(output_dir, 'errors.csv')
CSV.open(errors_csv_path, 'w', encoding: 'UTF-8') do |csv|
  csv << %w[row reason]
  error_rows.each { |err| csv << err }
end

# підсумок у консоль
puts "Коректних: #{valid_contacts.size}, з помилками: #{error_rows.size}"