//
//  TokenModel.swift
//  09
//
//  Created by 김기영 on 2021/10/14.
//

import Foundation

struct TokenModel: Codable {
    let accessToken: String
    let refreshToken: String
    
    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

struct Token {
    static var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "token")
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
    
    static var refreshToken: String?{
        get {
            return UserDefaults.standard.string(forKey: "refreshToken")
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "refreshToken")
        }
    }
    
    static func logOut() {
        accessToken = nil
        refreshToken = nil
    }
}
