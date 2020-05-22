//
//  Router.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/19/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

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
        } catch {
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
            
        // let bodyParameters, let bodyEncoding, let urlParameters, let additionHeaders
        case .requestParametersAndHeaders(_, _, _, _):
            break
        }
        return request
    }
}
