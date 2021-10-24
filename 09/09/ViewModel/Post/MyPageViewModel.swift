//
//  MyPageViewModel.swift
//  09
//
//  Created by 김기영 on 2021/10/18.
//

import Foundation
import RxSwift
import RxCocoa

struct MyPageViewModel: ViewModelType {
    private let disposebag = DisposeBag()
    
    struct Input {
        let doneTap: Driver<Void>
        let doneTap1: Driver<Void>
        let doneTap2: Driver<Void>
        let showInfo: Signal<String>
        let page: Int
        let memberID: Int
    }
    
    struct Output {
        let result: Signal<String>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let result = PublishSubject<String>()
        
        input.doneTap.asObservable().subscribe(onNext: { _ in
            api.products(page: input.page, size: 16).subscribe({ _ in
                result.onCompleted()
            }).disposed(by: disposebag)
        }).disposed(by: disposebag)
        
        input.doneTap1.asObservable().subscribe(onNext: { _ in
            api.seeLikePost().subscribe({ _ in
                result.onCompleted()
            }).disposed(by: disposebag)
        }).disposed(by: disposebag)
        
        input.doneTap2.asObservable().subscribe(onNext: { _ in
            api.seeDeletePost(input.memberID).subscribe({ _ in
                result.onCompleted()
            }).disposed(by: disposebag)
        }).disposed(by: disposebag)
        
        input.showInfo.asObservable().subscribe(onNext: { _ in
            api.profile(input.memberID).subscribe({ _ in
                result.onCompleted()
            }).disposed(by: disposebag)
        }).disposed(by: disposebag)
        
        return Output(result: result.asSignal(onErrorJustReturn: "실패했다."))
    }
}
