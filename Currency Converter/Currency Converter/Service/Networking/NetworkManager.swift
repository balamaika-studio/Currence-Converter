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
    let exchangeRatesRouter = Router<ExchangeRatesApi>()
    private let baseCurrency = "EUR"

    func getAllCurrencies(exchangeType: ExchangeType, completion: @escaping (_ response: CurrencyListResponse?, _ error: String?) -> Void) {
        exchangeRatesRouter.request(.list(type: exchangeType)) { data, response, error in
            self.build(CurrencyListResponse.self,
                       with: (data, response, error),
                       callback: completion)
        }
    }
    
    func getQuotes(exchangeType: ExchangeType, completion: @escaping (_ response: ExchangeRatesHistoryResponse?, _ error: String?) -> Void) {
        exchangeRatesRouter.request(.live(base: baseCurrency, type: exchangeType)) { data, response, error in
            self.build(ExchangeRatesHistoryResponse.self,
                       with: (data, response, error),
                       callback: completion)
        }
    }
    
    func getQuotes(date: Date,
                   completion: @escaping (_ response: ExchangeRatesHistoryResponse?,_ error: String?) -> Void) {
        exchangeRatesRouter.request(.historical(date: date)) { data, response, error in
            self.build(ExchangeRatesHistoryResponse.self,
                        with: (data, response, error),
                        callback: completion)
        }
    }

    func getForexGraphsQuotes(id: String, start: String, end: String,
                   completion: @escaping (_ response: ExchangeRatesTimeSeriesResponse?,_ error: String?) -> Void) {
        exchangeRatesRouter
            .request(.timeFrameForex(id: id, start: start, end: end)) { data, response, error in
            self.build(ExchangeRatesTimeSeriesResponse.self,
                       with: (data, response, error),
                       callback: completion)
        }
    }

    func getCryptoGraphsQuotes(id: String, start: String, end: String,
                   completion: @escaping (_ response: ExchangeRatesTimeSeriesResponse?,_ error: String?) -> Void) {
        exchangeRatesRouter
            .request(.timeFrameCrypto(id: id, start: start, end: end)) { data, response, error in
            self.build(ExchangeRatesTimeSeriesResponse.self,
                       with: (data, response, error),
                       callback: completion)
        }
    }

    func getLastChangeForex(
        type: ExchangeType,
        currencies: [String],
        completion: @escaping (
            _ response: LastCandleArrayResponse?,
            _ error: String?
        ) -> Void
    ) {
        exchangeRatesRouter.request(.lastCandleForex(
            symbols: currencies,
            period: .oneDay
        )) { data, response, error in
            self.build(
                LastCandleArrayResponse.self,
                with: (data, response, error),
                callback: completion
            )
        }
    }

    func getLastChangeCrypto(
        type: ExchangeType,
        currencies: [String],
        completion: @escaping (
            _ response: LastCandleArrayResponse?,
            _ error: String?
        ) -> Void
    ) {
        exchangeRatesRouter.request(.lastCandleCrypto(
            symbols: currencies,
            period: .oneDay
        )) { data, response, error in
            self.build(
                LastCandleArrayResponse.self,
                with: (data, response, error),
                callback: completion
            )
        }
    }
    
    // MARK: - Private Methods
    private func build<T: Decodable>(_ type: T.Type,
                                    with routerData: RouterCompletionData,
                                    callback completion: @escaping (_ answer: T?, _ error: String?) -> Void) {
        if routerData.error != nil {
            DispatchQueue.main.async {
                completion(nil, R.string.localizable.networkConnection())
            }
        }
        
        if let response = routerData.response as? HTTPURLResponse {
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let responseData = routerData.data else {
                    DispatchQueue.main.async {
                        completion(nil, NetworkResponse.noData.description)
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
                        completion(nil, NetworkResponse.unableToDecode.description)
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
        case 401...500: return .failure(NetworkResponse.authenticationError.description)
        case 501...599: return .failure(NetworkResponse.badRequest.description)
        case 600: return .failure(NetworkResponse.outdated.description)
        default: return .failure(NetworkResponse.failed.description)
        }
    }
}

enum NetworkResponse {
    case success
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
}

extension NetworkResponse: CustomStringConvertible {
    var description: String {
        switch self {
        case .authenticationError: return R.string.localizable.networkAuthentication()
        case .badRequest: return R.string.localizable.badRequest()
        case .outdated: return R.string.localizable.outdatedURL()
        case .failed: return R.string.localizable.requestFailed()
        case .noData: return R.string.localizable.networkNoData()
        case .unableToDecode: return R.string.localizable.decodeProblem()
        default: return String()
        }
    }
}

enum NetworkingResult<String>{
    case success
    case failure(String)
}
