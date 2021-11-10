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
        let price: Int?
        let transactionRegion: Driver<String>
        let openChatLink: Driver<String>
        let image: Driver<Data>
        let doneTap: Signal<Void>
    }
    
    struct Output{
        let isEnable: Driver<Bool>
        let result: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let result = PublishRelay<Bool>()
        let info = Driver.combineLatest(input.title, input.content, input.transactionRegion,
                                        input.openChatLink, input.image)
        let isEnabel = info.map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty && !$0.3.isEmpty
            && !$0.4.isEmpty
        }
        
        input.doneTap.asObservable()
            .withLatestFrom(info)
            .flatMap { title, content, transactionRegion, openChatLink, image in
                api.post(title: title, content: content, price: input.price ?? 0, transactionRegion: transactionRegion, openChatLink: openChatLink, image: image)
            }.subscribe(onNext: { res in
                switch res {
                case .createOk:
                    result.accept(true)
                default:
                    result.accept(false)
                }
            }).disposed(by: disposebag)
        
        return Output(isEnable: isEnabel.asDriver(onErrorJustReturn: false), result: result)
    }
}
