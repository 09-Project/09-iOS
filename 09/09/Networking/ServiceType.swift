//
//  ServiceType.swift
//  09
//
//  Created by 김기영 on 2021/10/13.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

class ServiceType {
    let baseURL = "http://3.36.26.221:8080"
    
    typealias httpResults = Observable<(HTTPURLResponse, Data)>
    
    func resultData(_ api: API) -> httpResults {
        return RxAlamofire.requestData(api.method(), baseURL + api.path(), parameters: api.param,
                                    encoding: JSONEncoding.prettyPrinted, headers: api.header())
    }
}

enum networkingResult: Int {
    case ok = 200
    case deleteOk = 204
    case okay = 201
    case wrongRq = 400
    case tokenError = 401
    case notFound = 404
    case conflict = 409
    case fault = 0
}
