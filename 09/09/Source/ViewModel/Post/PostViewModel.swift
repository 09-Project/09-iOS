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
    private var posts = [PostModel]()
    
    struct Input {
        let getPost: Signal<Void>
        let flagIt: Driver<Int>
        let deleteFlagIt: Driver<Int>
    }
    
    struct Output {
        let getPostResult: PublishRelay<Bool>
        let post: BehaviorRelay<[PostModel]>
        let flagItResult: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let getPostResult = PublishRelay<Bool>()
        let post = BehaviorRelay<[PostModel]>(value: [])
        let flagItResult = PublishRelay<Bool>()
        
        input.getPost.asObservable().flatMap{ _ in api.products(page: 0, size: 6)}
        .subscribe(onNext: { data, res in
            switch res {
            case .ok:
                post.accept(data!.posts)
                getPostResult.accept(true)
            default:
                print(res)
                getPostResult.accept(false)
            }
        }).disposed(by: disposebag)
        
        input.flagIt.asObservable().flatMap{ row in
            api.like(self.posts[row].id)
        }.subscribe(onNext: { res in
            switch res {
            case .ok:
                flagItResult.accept(true)
            default:
                flagItResult.accept(false)
            }
        }).disposed(by: disposebag)
        
        input.deleteFlagIt.asObservable().flatMap{ row in
            api.like(self.posts[row].id)
        }.subscribe(onNext: { res in
            switch res {
            case .ok:
                flagItResult.accept(true)
            default:
                flagItResult.accept(false)
            }
        }).disposed(by: disposebag)
        
        return Output(getPostResult: getPostResult, post: post, flagItResult: flagItResult)
}

}
