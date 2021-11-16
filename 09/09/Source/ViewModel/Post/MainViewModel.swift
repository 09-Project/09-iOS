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
    
    struct Input {
        let getPost: Signal<Void>
        let getMorePost: Signal<Void>
        let getBackPost: Signal<Void>
        let searchBtn: Signal<Void>
        let searchTxt: Signal<String?>
        let flagIt: Driver<Int>
        let deleteFlagIt: Driver<Int>
        let refresh: Driver<Void>
        let loadDetail: Signal<IndexPath>
        let count: Driver<Void>
    }
    
    struct Output {
        let getPostResult: PublishRelay<Bool>
        let post: BehaviorRelay<[PostModel]>
        let flagItResult: PublishRelay<Bool>
        let refreshResult: PublishRelay<Bool>
        let detailIndex: Signal<Int>
        let PostCount: PublishRelay<Int>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let getPostResult = PublishRelay<Bool>()
        let post = BehaviorRelay<[PostModel]>(value: [])
        let flagItResult = PublishRelay<Bool>()
        let refreshResult = PublishRelay<Bool>()
        let detailIndex = PublishRelay<Int>()
        let count = PublishRelay<Int>()
        
        var page = 0
        
        input.getPost.asObservable().flatMap{ _ in
            api.products(page: 0)}
        .subscribe(onNext: { data, res in
            switch res {
            case .ok:
                post.accept(data!.posts)
                getPostResult.accept(true)
            default:
                getPostResult.accept(false)
            }
        }).disposed(by: disposebag)
  
        input.getMorePost.asObservable().map{ page += 1 }.flatMap{ _ in
            api.products(page: page)
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
            api.products(page: page)
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
            api.search(keywords: text!, page: 0)
        }.subscribe(onNext: { data, res in
            switch res {
            case .ok:
                post.accept(data!.posts)
            default:
                print(res)
            }
        }).disposed(by: disposebag)
        
        input.flagIt.asObservable().flatMap{ row in
            api.like(post.value[row].id)
        }.subscribe(onNext: { res in
            switch res {
            case .createOk:
                flagItResult.accept(true)
            default:
                flagItResult.accept(false)
            }
        }).disposed(by: disposebag)
        
        input.deleteFlagIt.asObservable().flatMap{ row in
            api.deleteLike(post.value[row].id)
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
        
        input.loadDetail.asObservable().subscribe(onNext: { index in
            let value = post.value
            detailIndex.accept(value[index.row].id)
        }).disposed(by: disposebag)
        
        input.count.asObservable().flatMap{ _ in
            api.products(page: 0)
        }.subscribe(onNext: { data, res in
            switch res {
            case .ok:
                count.accept(data!.count)
            default:
                count.accept(0)
            }
        }).disposed(by: disposebag)

        return Output(getPostResult: getPostResult, post: post, flagItResult: flagItResult,
                      refreshResult: refreshResult, detailIndex: detailIndex.asSignal(),
                      PostCount: count)
    }
}
