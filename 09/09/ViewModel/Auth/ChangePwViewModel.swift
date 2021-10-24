//
//  CheckPwViewModel.swift
//  09
//
//  Created by 김기영 on 2021/10/14.
//

import Foundation
import RxSwift
import RxCocoa

class ChangePwViewModel: ViewModelType {
    
    private let disposebag = DisposeBag()
    
    struct Input {
        let password: Driver<String>
        let new_password: Driver<String>
        let check_password: Driver<String>
        let doneTap: Signal<Void>
    }
    
    struct Output {
        let isEnable: Driver<Bool>
        let result: Signal<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let result = PublishSubject<Bool>()
        let info = Driver.combineLatest(input.password, input.new_password, input.check_password)
        let isEnable = info.map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty}
        
        input.doneTap.asObservable().withLatestFrom(info)
            .flatMap{ pw, newPw, checkPw in
                api.changePW(pw, newPw)
            }.subscribe(onNext: { _ in
                result.onCompleted()
            }).disposed(by: disposebag)
        
       return Output(isEnable: isEnable.asDriver(),
               result: result.asSignal(onErrorJustReturn: false))
    }
}
