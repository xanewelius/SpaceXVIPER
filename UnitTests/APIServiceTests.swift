import XCTest
import Foundation

final class APIServiceTests: XCTestCase {
    
    // MARK: - Test fetch ship success
    
    func testFetchShipSuccess() async throws {
        // Given: Задана успешное сетевое подключение с корректными данными
        
        let mockNetworkClient = MockNetworkClient()
        let sampleShip = Ship(
            shipId: "AMERICANCHEMPION",
            shipName: "American Chempion",
            shipModel: "Model X",
            shipType: "Tug",
            roles: ["Support", "Carry"],
            active: false,
            yearBuilt: 1976,
            homePort: "Port of Los Angeles",
            image: "https://i.imgur.com/RnhZbAy.jpeg"
        )
        
        let ships = [sampleShip]
        let responseData = try JSONEncoder().encode(ships)
        mockNetworkClient.responseData = responseData
        let apiService = ShipsAPIService(networkClient: mockNetworkClient)
        
        // When: Когда вызывается метод fetchShips()
        
        let fetchedShips = try await apiService.fetchShips()
        
        // Then: Тогда получаем список кораблей и проверяем, что все данные корректные
        
        XCTAssertEqual(fetchedShips.count, 1)
        XCTAssertEqual(fetchedShips.first?.shipId, sampleShip.shipId)
        XCTAssertEqual(fetchedShips.first?.shipModel, sampleShip.shipModel)
        XCTAssertEqual(fetchedShips.first?.shipName, sampleShip.shipName)
    }
    
    // MARK: - Test fetch ships network error
    
    func testFetchShipsNetworkError() async throws {
        // Given: Задано сетевое соединение, которое возвращает ошибку
        
        let mockNetworkClient = MockNetworkClient()
        mockNetworkClient.responseError = APIError.network(NSError(domain: "Network error", code: -1009))
        
        let apiService = ShipsAPIService(networkClient: mockNetworkClient)
        
        // When: Когда вызывается метод fetchShips()
        
        do {
            let _ = try await apiService.fetchShips()
            XCTFail("Expected error, but got success")
        } catch let error as APIError {
            // Then: Тогда проверяем, что получена правильная ошибка
            switch error {
            case .network(let nsError as NSError):
                XCTAssertEqual(nsError.code, -1009)
            default:
                XCTFail("Expected network error, but got: \(error)")
            }
        } catch {
            XCTFail("Expected APIError, but got: \(error)")
        }
    }
    
    // MARK: - Test fetch ships invalid status code
    
    func testFetchShipsInvalidStatusCode() async throws {
        // Given: Задано сетевое подключение, которое возвращает статус-код 404
        
        let mockNetworkClient = MockNetworkClient()
        mockNetworkClient.responseData = Data()
        mockNetworkClient.responseStatusCode = 404
        let apiService = ShipsAPIService(networkClient: mockNetworkClient)
        
        // When: Когда вызывается метод fetchShips()
        
        do {
            let _ = try await apiService.fetchShips()
            XCTFail("Expected error, but got success")
        } catch let error as APIError {
            // Then: Тогда проверяем, что получена ошибка invalidResponse с кодом 404
            switch error {
            case .invalidReponse(let statusCode):
                XCTAssertEqual(statusCode, 404)
            default :
                XCTFail("Expected invalidResponse error, but got: \(error)")
            }
        } catch {
            XCTFail("Expected APIError, but got: \(error)")
        }
    }
    
    // MARK: - Test fetch ships decoding error
    
    func testFetchShipsDecodingError() async throws {
        // Given: Задано сетевое подключение, которое возвращает некорректные данные
        
        let mockNetworkClient = MockNetworkClient()
        mockNetworkClient.responseData = Data("Invalid JSON".utf8)
        let apiService = ShipsAPIService(networkClient: mockNetworkClient)
        
        // When: Когда вызывается метод fetchShips()
        
        do {
            let _ = try await apiService.fetchShips()
            XCTFail("Expected error, but got seccess")
        } catch let error as APIError {
            // Then: Тогда проверяем, что получена ошибка декодирования
            switch error {
            case .decoding:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected decoding error, but got \(error)")
            }
        } catch {
            XCTFail("Expected APIError, but got \(error)")
        }
    }
    
    // MARK: - test fetch ships empty list
    
    func testFetchShipsEmptyList() async throws {
        // Given: Задано сетевое подключение, но пришел пустой список
        
        let mockNetworkClient = MockNetworkClient()
        let ships = [Ship]()
        let responseData = try JSONEncoder().encode(ships)
        mockNetworkClient.responseData = responseData
        let apiService = ShipsAPIService(networkClient: mockNetworkClient)
        
        // When: Когда вызывается метод fetchShips()
        
        let fetchedShips = try await apiService.fetchShips()
        
        // Then: Тогда получаем пустой список кораблей
        
        XCTAssertEqual(fetchedShips.count, 0)
    }
    
    // MARK: - Test fetch ships missing optional fields
    
    func testFetchShipsMissingOptionalFields() async throws {
        // Given: Задано сетевое подключение, которое возвращает данные с отсутствующими необязательными полями
        
        let mockNetworkClient = MockNetworkClient()
        let sampleShip = Ship(
            shipId: "TEST",
            shipName: "Test Ship",
            shipModel: nil, // Отсутствует модель
            shipType: nil,  // Отсутствует тип
            roles: nil,     // Отсутствует роли
            active: nil,    // Отсутствует статус активности
            yearBuilt: nil, // Отсутствует год постройки
            homePort: nil,  // Отсутствует порт приписки
            image: nil      // Отсутствует изображение
        )
        let ships = [sampleShip]
        let responseData = try JSONEncoder().encode(ships)
        mockNetworkClient.responseData = responseData
        let apiService = ShipsAPIService(networkClient: mockNetworkClient)
        
        // When: Когда вызывается метод fetchShips()
        
        let fetchedShips = try await apiService.fetchShips()
        
        // Then: Тогда получаем список кораблей и проверяем, что обязательные поля присутствуют
        
        XCTAssertEqual(fetchedShips.count, 1)
        XCTAssertEqual(fetchedShips.first?.shipId, sampleShip.shipId)
        XCTAssertEqual(fetchedShips.first?.shipName, sampleShip.shipName)
        XCTAssertNil(fetchedShips.first?.shipModel)
        XCTAssertNil(fetchedShips.first?.shipType)
        XCTAssertNil(fetchedShips.first?.roles)
        XCTAssertNil(fetchedShips.first?.active)
        XCTAssertNil(fetchedShips.first?.yearBuilt)
        XCTAssertNil(fetchedShips.first?.homePort)
    }
}
