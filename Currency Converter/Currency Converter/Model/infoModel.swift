//
//  infoModel.swift
//  Currency Converter
//
//  Created by Vlad Sys on 9.07.22.
//  Copyright © 2022 Kiryl Klimiankou. All rights reserved.
//

import Foundation

struct infoModel: Decodable {
    private enum CodingKeys: String, CodingKey {
        case base, type, server_time
    }

    let base: String
    let type: String
    let server_time: String
}
