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
        let getUserInfo: Signal<Void>
        let getPost: Signal<Void>
        let getLikePost: Signal<Void>
        let getDetail: Signal<Void>
        let memberID: Int
    }
    
    struct Output {
        let myInfo: PublishRelay<ProfileModel?>
        let post: BehaviorRelay<[PostModel]>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let userInfo = PublishRelay<ProfileModel?>()
        let post = BehaviorRelay<[PostModel]>(value: [])
        
        input.getUserInfo.asObservable().flatMap { _ in
            api.myPage()
        }.subscribe(onNext: { data, res in
            print(data!)
            switch res {
            case .ok:
                userInfo.accept(data!)
            default:
                userInfo.accept(nil)
            }
        }).disposed(by: disposebag)
        
        input.getPost.asObservable().flatMap {
            _ in api.products(page: 0)
        }.subscribe(onNext: { data, res in
            switch res {
            case .ok:
                post.accept(data!.posts)
            default:
                print(data)
            }
        }).disposed(by: disposebag)
        
        input.getLikePost.asObservable().flatMap {
            _ in api.seeLikePost()
        }.subscribe(onNext: { data, res in
            switch res {
            case .ok:
                post.accept(data!)
            default:
                print(data)
            }
        }).disposed(by: disposebag)
        
        input.getDetail.asObservable().flatMap { _ in
            api.seeDeletePost(input.memberID)
        }.subscribe(onNext: { data, res in
            switch res {
            case .ok:
                post.accept(data!)
            default:
                print(data)
            }
        }).disposed(by: disposebag)
        
        return Output(myInfo: userInfo, post: post)
    }
}
