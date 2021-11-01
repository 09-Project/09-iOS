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
        let getPost: Signal<Void>
        let getMorePost: Signal<Void>
        let getBackPost: Signal<Void>
    }
    
    struct Output {
        let getPostResult: PublishRelay<Bool>
        let post: BehaviorRelay<[PostModel]>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let getPostResult = PublishRelay<Bool>()
        let post = BehaviorRelay<[PostModel]>(value: [])
        var page = 0
        
        input.getPost.asObservable().flatMap{ _ in api.products(page: 0, size: 16)}
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
        
        input.getMorePost.asObservable().map{ page += 1 }.flatMap{ _ in
            api.products(page: page, size: 16)
        }.subscribe(onNext: { data, res in
            switch res {
            case .ok:
                post.accept(data!.posts)
                getPostResult.accept(true)
            default:
                print(res)
                getPostResult.accept(false)
            }
        }).disposed(by: disposebag)
        
        input.getBackPost.asObservable().map{ page -= 1}.flatMap{ _ in
            api.products(page: page, size: 16)
        }.subscribe(onNext: { data, res in
            switch res {
            case .ok:
                post.accept(data!.posts)
                getPostResult.accept(true)
            default:
                print(res)
                getPostResult.accept(false)
            }
        }).disposed(by: disposebag)
        
        
        return Output(getPostResult: getPostResult, post: post)
    }
}

