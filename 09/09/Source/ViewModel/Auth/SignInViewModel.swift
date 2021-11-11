//
//  SignInModel.swift
//  09
//
//  Created by 김기영 on 2021/10/14.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel: ViewModelType {
    
    private let disposebag = DisposeBag()
    
    struct Input {
        let username: Driver<String>
        let password: Driver<String>
        let doneTap: Signal<Void>
    }
    
    struct Output {
        let result: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let info = Driver.combineLatest(input.username, input.password)
        let result = PublishRelay<Bool>()
        
        input.doneTap.withLatestFrom(info).asObservable().flatMap{ userN, userP in
            api.signIn(userN, userP)
        }.subscribe(onNext: { res in
            switch res {
            case .ok :
                result.accept(true)
            default:
                result.accept(false)
            }
        }).disposed(by: disposebag)
        
        return Output(result: result)
    }
}
