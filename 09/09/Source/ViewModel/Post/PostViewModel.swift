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
        let getDetail: Driver<Void>
        let post_id: Int
        let getPost: Driver<Void>
        let flagIt: Driver<Int>
        let deleteFlagIt: Driver<Int>
    }
    
    struct Output {
        let getPostResult: PublishRelay<Bool>
        let post: BehaviorRelay<[OtherModel]>
        let flagItResult: PublishRelay<Bool>
        let postInformation: PublishRelay<SeePostModel?>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let getPostResult = PublishRelay<Bool>()
        let post = BehaviorRelay<[OtherModel]>(value: [])
        let flagItResult = PublishRelay<Bool>()
        let detailPost = PublishRelay<SeePostModel?>()
        
        input.getPost.asObservable().flatMap{ _ in
            api.other()
        }.subscribe(onNext: { data, res in
            switch res {
            case .ok:
                post.accept(data!.OtherList)
                getPostResult.accept(true)
            default:
                print(res)
                getPostResult.accept(false)
            }
        }).disposed(by: disposebag)
        
        input.flagIt.asObservable().flatMap{ num in
            api.like(num)
        }.subscribe(onNext: { res in
            switch res {
            case .createOk:
                flagItResult.accept(true)
            default:
                flagItResult.accept(false)
            }
        }).disposed(by: disposebag)
        
        input.deleteFlagIt.asObservable().flatMap{ num in
            api.deleteLike(num)
        }.subscribe(onNext: { res in
            switch res {
            case .deleteOk:
                flagItResult.accept(false)
            default:
                flagItResult.accept(true)
            }
        }).disposed(by: disposebag)
        
        input.getDetail.asObservable().flatMap{ _ in
            api.seeProducts(input.post_id)
        }.subscribe(onNext: { data, res in
            switch res {
            case .ok:
                detailPost.accept(data!)
            default:
                detailPost.accept(nil)
            }
        }).disposed(by: disposebag)
        
        return Output(getPostResult: getPostResult, post: post, flagItResult: flagItResult,
                      postInformation: detailPost)
    }
}

