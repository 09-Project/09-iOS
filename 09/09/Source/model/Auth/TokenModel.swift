//
//  TokenModel.swift
//  09
//
//  Created by 김기영 on 2021/10/14.
//

import Foundation

struct TokenModel: Codable {
    let access_token: String
    let refresh_token: String
}

struct Token {
    
    static var _accessToken: String?
    static var accessToken: String? {
        get {
            _accessToken = UserDefaults.standard.string(forKey: "token")
            return _accessToken
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "token")
            _accessToken = UserDefaults.standard.string(forKey: "token")
        }
    }
    
    static var _refreshToken: String?
    static var refreshToken: String?{
        get {
            _refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
            return _refreshToken
        }
        set {
             UserDefaults.standard.set(newValue, forKey: "refreshToken")
            _refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        }
    }
    
    static func logOut() {
        accessToken = nil
        refreshToken = nil
    }
}
