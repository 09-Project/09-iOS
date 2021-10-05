//
//  File.swift
//  09
//
//  Created by 김기영 on 2021/09/10.
//

import Foundation
import Alamofire

enum API {
    case signUP(_ name: String, _ username: String, _ password: String)
    case signIn(_ username: String, _ password: String)
    case reissue(_ access_token: String, _ refresh_token: String)
    case changepw(_ password: String, _ new_password: String)
}
