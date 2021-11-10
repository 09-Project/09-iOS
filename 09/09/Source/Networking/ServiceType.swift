//
//  ServiceType.swift
//  09
//
//  Created by 김기영 on 2021/10/13.
//

import Foundation

enum networkingResult: Int {
    case ok = 200
    case deleteOk = 204
    case createOk = 201
    case wrongRq = 400
    case tokenError = 401
    case notFound = 404
    case conflict = 409
    case fault = 0
}
