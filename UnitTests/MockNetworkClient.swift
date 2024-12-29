import Foundation

final class MockNetworkClient: NetworkClient {
    
    // MARK: - Properties
    
    ///Данные, которые будут возвращены в ответ на запрос
    var responseData: Data?
    
    ///Ошибка, которая будет выброшена при выполнение запроса
    var responseError: Error?
    
    ///HTTP статус-код, который будет возвращен
    var responseStatusCode: Int = 200
    
    // MARK: - Methods
    
    func sendRequest<T: Decodable>(_ request: NetworkRequest) async throws -> T {
        // Given: Задано состояние сети с возможной задержкой и заданными ответами
        
        // Эмулируем задержку сети
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 секунды
        
        // When: Когда выполняется сетевой запрос
        
        // Проверяем, есть ли ошибка, которую нужно выбросить
        if let error = responseError {
            throw error
        }
        
        // Проверяем, есть ли данные для возврата
        guard let data = responseData else {
            throw APIError.network(NSError(domain: "No data", code: -1))
        }
        
        // Проверяем статус-код ответа
        guard (200...299).contains(responseStatusCode) else {
            throw APIError.invalidReponse(statusCode: responseStatusCode)
        }
        
        // Then: Тогда возвращаем декодированные данные или выбрасываем ошибку декодирования
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}
