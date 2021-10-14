//
//  TokenModel.swift
//  09
//
//  Created by 김기영 on 2021/10/14.
//

import Foundation

struct TokenModel: Codable {
    let accessToken: String
    let refrsehToken: String
    
}

struct Token {
    static var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "token")
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
}
