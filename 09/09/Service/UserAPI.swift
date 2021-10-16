//
//  UserAPI.swift
//  09
//
//  Created by 김기영 on 2021/10/16.
//

import Foundation
import RxSwift
import RxCocoa

class UserAPI {
    let baseURL = "http://3.36.26.221:8080"
    let request = ServiceType()
    
    func getInformation() -> Observable<networkingResult> {
        request.resultData(.getInformation)
            .map{response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    return .ok
                case 400:
                    return .wrongRq
                case 401:
                    return .tokenError
                case 404:
                    return .notFound
                default:
                    print(response.statusCode)
                    return .fault
                }
            }
    }
    
    func profile(_ memberID: Int) -> Observable<networkingResult> {
        request.resultData(.profile(memberID))
            .map {response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    return .ok
                case 400:
                    return .wrongRq
                case 401:
                    return .tokenError
                case 404:
                    return .notFound
                default:
                    print(response.statusCode)
                    return .fault
                }
            }
    }
    
    func myPage() -> Observable<networkingResult> {
        request.resultData(.myPage)
            .map{ response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    return .ok
                case 400:
                    return .wrongRq
                case 401:
                    return .tokenError
                case 404:
                    return .notFound
                default:
                    print(response.statusCode)
                    return .fault
                }
            }
    }
}
