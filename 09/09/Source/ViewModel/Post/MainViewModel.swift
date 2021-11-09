//
//  MainViewModel.swift
//  09
//
//  Created by 김기영 on 2021/10/31.
//
import Foundation
import RxSwift
import RxCocoa

class MainViewModel: ViewModelType {
    
    private let disposebag = DisposeBag()
    
    private var posts = [PostModel]()
    
    struct Input {
        let getPost: Signal<Void>
        let getMorePost: Signal<Void>
        let getBackPost: Signal<Void>
        let searchBtn: Signal<Void>
        let searchTxt: Signal<String?>
        let flagIt: Driver<Int>
        let deleteFlagIt: Driver<Int>
        let refresh: Driver<Void>
    }
    
    struct Output {
        let getPostResult: PublishRelay<Bool>
        let post: BehaviorRelay<[PostModel]>
        let flagItResult: PublishRelay<Bool>
        let refreshResult: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let getPostResult = PublishRelay<Bool>()
        let post = BehaviorRelay<[PostModel]>(value: [])
        let flagItResult = PublishRelay<Bool>()
        let refreshResult = PublishRelay<Bool>()
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
        
        input.getBackPost.asObservable().map{ page -= 1 }.flatMap{ _ in
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
        
        input.searchBtn.asObservable().withLatestFrom(input.searchTxt).flatMap{ text in
            api.search(keywords: text!, page: page, size: 16)
        }.subscribe(onNext: { data, res in
            switch res {
            case .ok:
                post.accept(data!.posts)
            default:
                print(res)
            }
        }).disposed(by: disposebag)
        
        input.flagIt.asObservable().flatMap{ row in
            api.like(self.posts[row].id)
        }.subscribe(onNext: { res in
            switch res {
            case .okay:
                flagItResult.accept(true)
            default:
                flagItResult.accept(false)
            }
        }).disposed(by: disposebag)
        
        input.deleteFlagIt.asObservable().flatMap{ row in
            api.delete(self.posts[row].id)
        }.subscribe(onNext: { res in
            switch res {
            case .deleteOk:
                flagItResult.accept(false)
            default:
                flagItResult.accept(true)
            }
        }).disposed(by: disposebag)
        
        input.refresh.asObservable().flatMap{ _ in
            api.refreshToken()
        }.subscribe(onNext: { res in
            switch res {
            case .ok:
                refreshResult.accept(true)
            default:
                refreshResult.accept(false)
            }
        }).disposed(by: disposebag)
        
        return Output(getPostResult: getPostResult, post: post, flagItResult: flagItResult, refreshResult: refreshResult)
    }
}


