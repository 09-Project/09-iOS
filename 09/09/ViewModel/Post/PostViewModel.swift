//
//  ViewModel.swift
//  09
//
//  Created by 김기영 on 2021/10/26.
//

import Foundation
import RxSwift
import RxCocoa

class PostViewModel: ViewModelType {
    private let disposebag = DisposeBag()
    
    struct Input {
        let getPost: Driver<Void>
    }
    
    struct Output {
        let getPostResult: PublishRelay<Bool>
        let post: BehaviorRelay<[PostModel]>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let getPostResult = PublishRelay<Bool>()
        let post = BehaviorRelay<[PostModel]>(value: [])
        
        input.getPost.asObservable().flatMap{_ in api.products(page: 8, size: 4)}
        .subscribe(onNext: { data, res in
            switch res {
            case .ok:
                post.accept(data!.PostList)
            default:
                getPostResult.accept(false)
            }
        }).disposed(by: disposebag)
        
        return Output(getPostResult: getPostResult, post: post)
    }
}
