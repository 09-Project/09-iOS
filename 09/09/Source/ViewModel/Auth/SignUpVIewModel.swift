//
//  SignUpVIewModel.swift
//  09
//
//  Created by 김기영 on 2021/10/14.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {
    
    private let disposebag = DisposeBag()
    
    struct Input {
        let name: Driver<String>
        let username: Driver<String>
        let password: Driver<String>
        let doneTap: Signal<Void>
    }
    
    struct Output {
        let result: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let info = Driver.combineLatest(input.name, input.username, input.password)
        let result = PublishRelay<Bool>()
        
        input.doneTap.asObservable()
            .withLatestFrom(info)
            .flatMap{ name, userN, userP in
                api.signUp(name, userN, userP)
            }.subscribe(onNext: { res in
                switch res {
                case .createOk:
                    result.accept(true)
                default:
                    result.accept(false)
                }
            }).disposed(by: disposebag)
        return Output(result: result)
    }
}
