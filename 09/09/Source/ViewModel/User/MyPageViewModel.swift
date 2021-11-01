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
        let getUserInfo: Driver<Void>
        let getPost: Driver<Void>
        let getLikePost: Driver<Void>
        let getDetail: Driver<Void>
        let memberID: Int
    }
    
    struct Output {
        let getUserInfoResult: PublishRelay<Bool>
        let myInfo: PublishRelay<ProfileModel>
        let post: BehaviorRelay<[PostModel]>
        let getPostResult: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let getInfoResult = PublishRelay<Bool>()
        let userInfo = PublishRelay<ProfileModel>()
        let post = BehaviorRelay<[PostModel]>(value: [])
        let getPostResult = PublishRelay<Bool>()
        
        input.getUserInfo.asObservable().flatMap { _ in
            api.myPage()
        }.subscribe(onNext: { data, res in
            switch res {
            case .ok:
                userInfo.accept(data!.self)
            default:
                getInfoResult.accept(false)
            }
        }).disposed(by: disposebag)
        
        input.getPost.asObservable().flatMap {
            _ in api.products(page: 0, size: 8)
        }.subscribe(onNext: { data, res in
            switch res {
            case .ok:
                post.accept(data!.posts)
            default:
                getPostResult.accept(false)
            }
        }).disposed(by: disposebag)
        
        input.getLikePost.asObservable().flatMap {
            _ in api.seeLikePost()
        }.subscribe(onNext: { data, res in
            switch res {
            case .ok:
                post.accept(data!.posts)
            default:
                getPostResult.accept(false)
            }
        }).disposed(by: disposebag)
        
        input.getDetail.asObservable().flatMap { _ in
            api.seeDeletePost(input.memberID)
        }.subscribe(onNext: { data, res in
            switch res {
            case .ok:
                post.accept(data!.posts)
            default:
                getPostResult.accept(false)
            }
        }).disposed(by: disposebag)
        
        return Output(getUserInfoResult: getInfoResult, myInfo: userInfo, post: post,
                      getPostResult: getPostResult)
    }
}
