//
//  NetworkManager.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/25/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

public typealias RouterCompletionData = (
    data: Data?,
    response: URLResponse?,
    error: Error?
)

struct NetworkManager {
    let router = Router<CurrencyLayerApi>()
    private let baseCurrency = "EUR"
    static let movieAPIKey = "816f75b418e0a37e105feaabd5585cc3"
    
    func getQuotes(completion: @escaping (_ response: RealTimeRatesResponse?, _ error: String?) -> Void) {
        router.request(.live(source: baseCurrency)) { data, response, error in
            self.build(RealTimeRatesResponse.self,
                       with: (data, response, error),
                       callback: completion)
        }
    }
    
    func getQuotes(date: String,
                   completion: @escaping (_ response: RealTimeRatesResponse?,_ error: String?) -> Void) {
        router.request(.historical(date: date)) { data, response, error in
            self.build(RealTimeRatesResponse.self,
                        with: (data, response, error),
                        callback: completion)
        }
    }
    
    // MARK: - Private Methods
    private func build<T: Decodable>(_ type: T.Type,
                                    with routerData: RouterCompletionData,
                                    callback completion: @escaping (_ answer: T?, _ error: String?) -> Void) {
        if routerData.error != nil {
            DispatchQueue.main.async {
                completion(nil, "Please check your network connection.")
            }
        }
        
        if let response = routerData.response as? HTTPURLResponse {
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let responseData = routerData.data else {
                    DispatchQueue.main.async {
                        completion(nil, NetworkResponse.noData.rawValue)
                    }
                    return
                }
                do {
                    let apiResponse = try self.decode(type, from: responseData)
                    DispatchQueue.main.async {
                        completion(apiResponse, nil)
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                }
                
            case .failure(let networkFailureError):
                DispatchQueue.main.async {
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    private func decode<T: Decodable >(_ type: T.Type, from data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkingResult<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum NetworkingResult<String>{
    case success
    case failure(String)
}
