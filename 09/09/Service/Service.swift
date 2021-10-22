//
//  AuthAPI.swift
//  09
//
//  Created by 김기영 on 2021/10/14.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import UIKit
import Tabman

final class Service {
    
    let provider = MoyaProvider<API>()
    
    func signIn(_ username: String, _ password: String) -> Observable<networkingResult> {
        return provider.rx.request(.signIn(username, password))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(TokenModel.self)
            .map{ response -> networkingResult in
                if (Token.accessToken == response.accessToken && Token.refreshToken == response.refreshToken)
                {
                    return .ok
                }
                else { return .fault}
            }.catchError{ [unowned self] in return .just(setNetWorkError($0))}
        
    }
    
    func signUp(_ name: String, _ username: String, _ password: String) ->
    Observable<networkingResult> {
        return provider.rx.request(.signUp(name, username, password))
            .filterSuccessfulStatusCodes()
            .asObservable().map{ _ -> networkingResult in return .okay}
            .catchError{ [unowned self] in return .just(setNetWorkError($0)) }
    }
    
    func changePW(_ password: String, _ new_password: String) -> Observable<networkingResult> {
        return provider.rx.request(.changepw(password, new_password))
            .filterSuccessfulStatusCodes()
            .asObservable().map { _ -> networkingResult in return .okay}
            .catchError{ [unowned self] in return .just(setNetWorkError($0))}
    }
    
    func refreshToken() -> Observable<networkingResult> {
        provider.rx.request(.refreshToken)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(TokenModel.self)
            .map { response -> networkingResult in
                if(Token.accessToken == response.accessToken && Token.refreshToken == response.refreshToken)
                {
                    return .ok
                }
                else {
                    return .fault
                }
            }
            .catchError{ [unowned self] in return .just(setNetWorkError($0))}
    }
    
    
    
    func setNetWorkError(_ error: Error) -> networkingResult {
        print(error)
        guard let stauts = (error as? MoyaError)?.response?.statusCode else {return .fault}
        return (networkingResult(rawValue: stauts) ?? .fault)
    }
}
