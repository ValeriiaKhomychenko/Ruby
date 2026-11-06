# Помилка для неправильного формату координат або виходу за межі поля
class InvalidCoordinateError < StandardError; end

# Помилка, коли гравець стріляє в клітинку, в яку вже стріляв раніше
class RepeatedShotError < StandardError; end