import Foundation

enum RequestError: String, Error, LocalizedError {
    case unauthorized = "❌ Вы не авторизованы ❌"
    case noRights = "❌ Нет прав доступа к содержимому ❌"
    case wrongSyntax = "❌ Неверный синтаксис запроса ❌"
    case server = "❌ Не удалось связаться с сервером. Проверьте соединение ❌"
    case client = "❌ Проверьте соединение с интернетом ❌"
    case noData = "❌ Данные не пришли ❌"
    case unableToDecode = "❌ Декодирование не удалось ❌"
    case unknown = "❌ Неизвестная ошибка ❌"

    var reason: String {
        return self.rawValue
    }
}
