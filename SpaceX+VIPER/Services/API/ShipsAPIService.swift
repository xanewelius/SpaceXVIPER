import Foundation

// MARK: - APIServiceType

protocol APIServiceType {
    func fetchShips() async throws -> [Ship]
}

// MARK: - ShipsAPIService

final class ShipsAPIService: APIServiceType {
    
    // MARK: - Private properties
    
    private let networkClient: NetworkClient
    private let baseURL: URL
    
    // MARK: - Initializer
    
    init(networkClient: NetworkClient = DefaultNetworkClient(), baseURL: URL = URL(string: "https://api.spacexdata.com")!) {
        self.networkClient = networkClient
        self.baseURL = baseURL
    }
    
    private func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else {
            throw APIError.invalidURL
        }
        
        let request = NetworkRequest(url: url, method: endpoint.method, headers: endpoint.headers, body: endpoint.body)
        
        return try await networkClient.sendRequest(request)
    }
    
    func fetchShips() async throws -> [Ship] {
        try await request(SpaceXEndpoint.ships)
    }
}


