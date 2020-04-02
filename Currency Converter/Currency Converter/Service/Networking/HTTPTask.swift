//
//  HTTPTask.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    case request
    
    case requestWithParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    
    // case download, upload...etc
}
