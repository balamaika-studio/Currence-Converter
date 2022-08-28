//
//  LastCandleResponse.swift
//  Currency Converter
//
//  Created by Vlad Sys on 1.08.22.
//  Copyright © 2022 Kiryl Klimiankou. All rights reserved.
//

import Foundation

// MARK: - Welcome
class LastCandleArrayResponse: Codable {
    let status: Bool?
    let code: Int?
    let msg: String?
    let response: [CandleResponse]?
    let info: Info?

    init(status: Bool?, code: Int?, msg: String?, response: [CandleResponse]?, info: Info?) {
        self.status = status
        self.code = code
        self.msg = msg
        self.response = response
        self.info = info
    }
}

// MARK: - Info
class Info: Codable {
    let serverTime: String?
    let creditCount: Int?

    enum CodingKeys: String, CodingKey {
        case serverTime = "server_time"
        case creditCount = "credit_count"
    }

    init(serverTime: String?, creditCount: Int?) {
        self.serverTime = serverTime
        self.creditCount = creditCount
    }
}

// MARK: - Response
class CandleResponse: Codable {
    let id, o, h, l: String?
    let c, t, up, ch: String?
    let cp, s, tm: String?

    init(id: String?, o: String?, h: String?, l: String?, c: String?, t: String?, up: String?, ch: String?, cp: String?, s: String?, tm: String?) {
        self.id = id
        self.o = o
        self.h = h
        self.l = l
        self.c = c
        self.t = t
        self.up = up
        self.ch = ch
        self.cp = cp
        self.s = s
        self.tm = tm
    }
}
