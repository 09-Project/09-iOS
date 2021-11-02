//
//  AuthAPI.swift
//  09
//
//  Created by 김기영 on 2021/10/14.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

final class Service {
    
    let provider = MoyaProvider<API>()
    
    func signIn(_ username: String, _ password: String) -> Single<networkingResult> {
        return provider.rx.request(.signIn(username, password))
            .filterSuccessfulStatusCodes()
            .map(TokenModel.self)
            .map{ response -> networkingResult in
                Token.accessToken = response.accessToken
                Token.refreshToken = response.refreshToken
                return .ok
            }
    }
    
    func signUp(_ name: String, _ username: String, _ password: String) ->
    Single<networkingResult> {
        return provider.rx.request(.signUp(name, username, password))
            .filterSuccessfulStatusCodes()
            .map{ _ -> networkingResult in return .okay}
    }
    
    func changePW(_ password: String, _ new_password: String) -> Single<networkingResult> {
        return provider.rx.request(.changepw(password, new_password))
            .filterSuccessfulStatusCodes()
            .map{ _ -> networkingResult in  return .deleteOk}
    }
    
    func refreshToken() -> Single<networkingResult> {
        return provider.rx.request(.refreshToken)
            .filterSuccessfulStatusCodes()
            .map(TokenModel.self)
            .map { response -> networkingResult in
                Token.accessToken = response.accessToken
                Token.refreshToken = response.refreshToken
                return .ok
            }
    }
    
    func delete(_ post_id: Int) -> Single<networkingResult> {
        return provider.rx.request(.deleteProducts(post_id))
            .filterSuccessfulStatusCodes()
            .map{ _ -> networkingResult in return .deleteOk}
    }
    
    func seeProducts(_ post_id: Int) -> Single<(posts?, networkingResult)> {
        return provider.rx.request(.seeProducts(post_id))
            .filterSuccessfulStatusCodes()
            .map(posts.self)
            .map{return ($0, .ok)}
    }
    
    func products(page: Int, size: Int) -> Single<(posts?, networkingResult)> {
        return provider.rx.request(.products(page, size))
            .filterSuccessfulStatusCodes()
            .map(posts.self)
            .map{return ($0, .ok)}
    }
    
    func search(keywords: String, page: Int, size: Int) -> Single<(posts?,
                                                                   networkingResult)> {
        return provider.rx.request(.search(keywords, page, size))
            .filterSuccessfulStatusCodes()
            .map(posts.self)
            .map{return ($0, .ok)}
    }
    
    func other() -> Single<(OtherList?, networkingResult)> {
        return provider.rx.request(.other)
            .filterSuccessfulStatusCodes()
            .map(OtherList.self)
            .map{return ($0, .ok)}
    }
    
    func pathProducts(post_id: Int, title: String, content: String,price: Int,
                      transactionRegion: String, openChatLink: String, image: String) -> Single<networkingResult> {
        return provider.rx.request(.putProducts(post_id, title, content, price, transactionRegion,
                                                openChatLink, image))
            .filterSuccessfulStatusCodes()
            .map{_ -> networkingResult in return .deleteOk}
    }
    
    func post(title: String, content: String, price: Int, transactionRegion: String,
              openChatLink: String, image: String) -> Single<networkingResult> {
        return provider.rx.request(.postProducts(title, content, price, transactionRegion, openChatLink, image))
            .filterSuccessfulStatusCodes()
            .map{_ -> networkingResult in return .okay}
        
    }
    
    func end(_ post_id: Int) -> Single<networkingResult> {
        return provider.rx.request(.end(post_id))
            .filterSuccessfulStatusCodes()
            .map{_ -> networkingResult in return .okay}
    }
    
    func seeLikePost() -> Single<(posts?, networkingResult)> {
        return provider.rx.request(.seeLikePost)
            .filterSuccessfulStatusCodes()
            .map(posts.self)
            .map{return ($0, .ok)}
    }
    
    func getInformation() -> Single<(InformationModel?, networkingResult)> {
        return provider.rx.request(.getInformation)
            .filterSuccessfulStatusCodes()
            .map(InformationModel.self)
            .map{return ($0, .ok)}
    }
    
    func profile(_ memberID: Int) -> Single<(ProfileModel?, networkingResult)> {
        return provider.rx.request(.profile(memberID))
            .filterSuccessfulStatusCodes()
            .map(ProfileModel.self)
            .map{return ($0, .ok)}
    }
    
    func like(_ postID: Int) -> Single<networkingResult> {
        return provider.rx.request(.likeObj(postID))
            .filterSuccessfulStatusCodes()
            .map{_ -> networkingResult in return .okay}
    }
    
    func deleteLike(_ postId: Int) -> Single<networkingResult> {
        return provider.rx.request(.deleteLike(postId))
            .filterSuccessfulStatusCodes()
            .map{ _ -> networkingResult in return .deleteOk}
    }
    
    func seeDeletePost(_ memberID: Int) -> Single<(posts?, networkingResult)> {
        return provider.rx.request(.seeDeletePost(memberID))
            .filterSuccessfulStatusCodes()
            .map(posts.self)
            .map{return ($0, .ok)}
    }
    
    
    func myPage() -> Single<(ProfileModel?, networkingResult)> {
        return provider.rx.request(.myPage)
            .filterSuccessfulStatusCodes()
            .map(ProfileModel.self)
            .map{return ($0, .ok)}
    }
    
    func changeInformation(_ name: String, _ introduction: String, _ profileUrl: String) -> Single<networkingResult>
    {
        return provider.rx.request(.changeInformation(name, introduction, profileUrl))
            .filterSuccessfulStatusCodes()
            .map{_ -> networkingResult in return .ok}
    }
    
    
}
