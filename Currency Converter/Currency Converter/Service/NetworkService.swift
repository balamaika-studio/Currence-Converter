//
//  NetworkService.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/19/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

protocol Networking {
    var baseURL: String { get }
    func fetchData(completion: @escaping (Data?) -> Void)
}

class NetworkService: Networking {
    var baseURL: String {
        return "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
    }
    
    func fetchData(completion: @escaping (Data?) -> Void) {
        let url = URL(string: baseURL)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
}
