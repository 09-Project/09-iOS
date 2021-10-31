//
//  ChangeProfileViewModel.swift
//  09
//
//  Created by 김기영 on 2021/10/28.
//

import Foundation
import RxSwift
import RxCocoa

class ChangeProfileViewModel: ViewModelType {
    
    private let bag = DisposeBag()
    
    struct Input {
        let name: Driver<String>
        let introduction: Driver<String>
        let profileURL: Driver<String>
        let doneTap: Driver<Void>
    }
    
    struct Output {
        let result: Signal<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let result = PublishSubject<Bool>()
        let info = Driver.combineLatest(input.name, input.introduction, input.profileURL)
        
        input.doneTap.asObservable().withLatestFrom(info).flatMap{ name, introduction, profileUrl in
            api.changeInformation(name, introduction, profileUrl)
        }.subscribe(onNext: { res in
            switch res {
            case .ok:
                result.onNext(true)
            default:
                result.onNext(false)
            }
        }).disposed(by: bag)
        
        return Output(result: result.asSignal(onErrorJustReturn: false))
    }
}
