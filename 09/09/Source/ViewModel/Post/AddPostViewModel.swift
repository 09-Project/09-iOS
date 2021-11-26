//
//  PostViewModel.swift
//  09
//
//  Created by 김기영 on 2021/10/24.
//

import Foundation
import RxCocoa
import RxSwift

class AddPostViewModel: ViewModelType {
    
    private let disposebag = DisposeBag()
    struct Input {
        let title: Driver<String>
        let content: Driver<String>
        let price: Driver<String>
        let transactionRegion: Driver<String>
        let openChatLink: Driver<String>
        let image: Driver<Data>
        let doneTap: Signal<Void>
    }
    
    struct Output{
        let result: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let result = PublishRelay<Bool>()
        let info = Driver.combineLatest(input.title, input.content, input.price,
                                        input.transactionRegion, input.openChatLink, input.image)
        
        input.doneTap.asObservable()
            .withLatestFrom(info)
            .flatMap { title, content, price, transactionRegion, openChatLink, image in
                api.post(title: title, content: content, price: Int(price) ?? 0 , transactionRegion: transactionRegion, openChatLink: openChatLink, image: image)
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
