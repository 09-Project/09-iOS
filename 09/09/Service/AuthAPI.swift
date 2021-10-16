//
//  AuthAPI.swift
//  09
//
//  Created by 김기영 on 2021/10/14.
//

import Foundation
import RxSwift
import RxCocoa
import SystemConfiguration

class AuthAPI {
    let baseURL = "http://3.36.26.221:8080"
    let request = ServiceType()
    
    func signIn(_ username: String, _ password: String) -> Observable<networkingResult> {
        request.resultData(.signIn(username, password))
            .map {response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    return .ok
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
    
    func signUp(_ name: String, _ username: String, _ password: String) ->
    Observable<networkingResult> {
        request.resultData(.signUp(name, username, password))
            .map { response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode {
                case 201:
                    return .okay
                case 401:
                    return .tokenError
                case 409:
                    return .conflict
                default:
                    print(response.statusCode)
                    return .fault
                }
            }
    }
    
    func changePW(_ password: String, _ new_password: String) -> Observable<networkingResult> {
        request.resultData(.changepw(password, new_password))
            .map { response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode {
                case 201:
                    return .okay
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
    
    func refreshToken() -> Observable<networkingResult> {
        request.resultData(.refreshToken)
            .map { response, data -> networkingResult in
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
                    return .fault
                }
            }
    }
}
