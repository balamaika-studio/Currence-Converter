//
//  Router.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/19/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation
//
//protocol Networking {
//    var baseURL: String { get }
//    func fetchData(completion: @escaping (Data?) -> Void)
//}
//
//class NetworkService: Networking {
//    var baseURL: String {
//        return "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
//    }
//
//    func fetchData(completion: @escaping (Data?) -> Void) {
//        let url = URL(string: baseURL)!
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                completion(nil)
//                return
//            }
//            DispatchQueue.main.async {
//                completion(data)
//            }
//        }.resume()
//    }
//}


public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
                        
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        switch route.task {
        case .request:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        case .requestWithParameters(let bodyParameters, let bodyEncoding, let urlParameters):
            do {
                switch bodyEncoding {
                case .urlEncoding:
                    try URLParameterEncoder().encode(urlRequest: &request, with: urlParameters ?? Parameters())
                case .jsonEncoding:
                    try JSONParameterEncoder().encode(urlRequest: &request, with: bodyParameters ?? Parameters())
                case .urlAndJsonEncoding:
                    break
                }
            } catch {
                throw error
            }
            
        case .requestParametersAndHeaders(let bodyParameters, let bodyEncoding, let urlParameters, let additionHeaders):
            break
        }
        return request
    }
}
