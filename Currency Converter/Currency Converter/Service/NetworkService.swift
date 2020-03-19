//
//  NetworkService.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/19/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

protocol Networking {
    func fetchData(completion: @escaping (Data?) -> Void)
}

class NetworkService: Networking {
    func fetchData(completion: @escaping (Data?) -> Void) {
        let path = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
        let url = URL(string: path)!
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
