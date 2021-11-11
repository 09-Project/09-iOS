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
                Token.accessToken = response.access_token
                Token.refreshToken = response.refresh_token
                return .ok
            }
            .catch {[unowned self] in return .just(setNetworkError($0))}
    }
    
    func signUp(_ name: String, _ username: String, _ password: String) ->
    Single<networkingResult> {
        return provider.rx.request(.signUp(name, username, password))
            .filterSuccessfulStatusCodes()
            .map{ _ -> networkingResult in return .createOk}
            .catch{[unowned self] in return .just(setNetworkError($0))}
    }
    
    func changePW(_ password: String, _ new_password: String) -> Single<networkingResult> {
        return provider.rx.request(.changepw(password, new_password))
            .filterSuccessfulStatusCodes()
            .map{ _ -> networkingResult in  return .deleteOk}
            .catch{[unowned self] in return .just(setNetworkError($0))}
    }
    
    func refreshToken() -> Single<networkingResult> {
        return provider.rx.request(.refreshToken)
            .filterSuccessfulStatusCodes()
            .map(TokenModel.self)
            .map { response -> networkingResult in
                Token.accessToken = response.access_token
                Token.refreshToken = response.refresh_token
                return .ok
            }
            .catch{[unowned self ] in return .just(setNetworkError($0))}
    }
    
    func delete(_ post_id: Int) -> Single<networkingResult> {
        return provider.rx.request(.deleteProducts(post_id))
            .filterSuccessfulStatusCodes()
            .map{ _ -> networkingResult in return .deleteOk}
            .catch{ [unowned self] in return .just(setNetworkError($0))}
    }
    
    func seeProducts(_ post_id: Int) -> Single<(SeePostModel?, networkingResult)> {
        return provider.rx.request(.seeProducts(post_id))
            .filterSuccessfulStatusCodes()
            .map(SeePostModel.self)
            .map{return ($0, .ok)}
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func products(page: Int) -> Single<(Posts?, networkingResult)> {
        return provider.rx.request(.products(page))
            .filterSuccessfulStatusCodes()
            .map(Posts.self)
            .map{return ($0, .ok)}
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func search(keywords: String, page: Int) -> Single<(Posts?, networkingResult)> {
        return provider.rx.request(.search(keywords, page))
            .filterSuccessfulStatusCodes()
            .map(Posts.self)
            .map{return ($0, .ok)}
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
        
    }
    
    func other() -> Single<(OtherList?, networkingResult)> {
        return provider.rx.request(.other)
            .filterSuccessfulStatusCodes()
            .map(OtherList.self)
            .map{return ($0, .ok)}
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func pathProducts(post_id: Int, title: String, content: String,price: Int,
                      transactionRegion: String, openChatLink: String, image: Data) -> Single<networkingResult> {
        return provider.rx.request(.putProducts(post_id, title, content, price, transactionRegion,
                                                openChatLink, image))
            .filterSuccessfulStatusCodes()
            .map{_ -> networkingResult in return .deleteOk}
            .catch{ [unowned self] in return .just(setNetworkError($0))}
    }
    
    func post(title: String, content: String, price: Int, transactionRegion: String,
              openChatLink: String, image: Data) -> Single<networkingResult> {
        return provider.rx.request(.postProducts(title, content, price, transactionRegion, openChatLink, image))
            .filterSuccessfulStatusCodes()
            .map{_ -> networkingResult in return .createOk}
            .catch{ [unowned self] in return .just(setNetworkError($0))}
        
    }
    
    func end(_ post_id: Int) -> Single<networkingResult> {
        return provider.rx.request(.end(post_id))
            .filterSuccessfulStatusCodes()
            .map{_ -> networkingResult in return .createOk}
            .catch{ [unowned self] in return .just(setNetworkError($0))}
    }
    
    func seeLikePost() -> Single<(Posts?, networkingResult)> {
        return provider.rx.request(.seeLikePost)
            .filterSuccessfulStatusCodes()
            .map(Posts.self)
            .map{return ($0, .ok)}
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func getInformation() -> Single<(InformationModel?, networkingResult)> {
        return provider.rx.request(.getInformation)
            .filterSuccessfulStatusCodes()
            .map(InformationModel.self)
            .map{return ($0, .ok)}
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func profile(_ memberID: Int) -> Single<(ProfileModel?, networkingResult)> {
        return provider.rx.request(.profile(memberID))
            .filterSuccessfulStatusCodes()
            .map(ProfileModel.self)
            .map{return ($0, .ok)}
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func like(_ postID: Int) -> Single<networkingResult> {
        return provider.rx.request(.likeObj(postID))
            .filterSuccessfulStatusCodes()
            .map{_ -> networkingResult in return .createOk}
            .catch{ [unowned self] in return .just(setNetworkError($0))}
    }
    
    func deleteLike(_ postId: Int) -> Single<networkingResult> {
        return provider.rx.request(.deleteLike(postId))
            .filterSuccessfulStatusCodes()
            .map{ _ -> networkingResult in return .deleteOk}
            .catch{ [unowned self] in return .just(setNetworkError($0))}
    }
    
    func seeDeletePost(_ memberID: Int) -> Single<(Posts?, networkingResult)> {
        return provider.rx.request(.seeDeletePost(memberID))
            .filterSuccessfulStatusCodes()
            .map(Posts.self)
            .map{return ($0, .ok)}
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func myPage() -> Single<(ProfileModel?, networkingResult)> {
        return provider.rx.request(.myPage)
            .filterSuccessfulStatusCodes()
            .map(ProfileModel.self)
            .map{return ($0, .ok)}
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    
    func changeInformation(_ name: String, _ introduction: String, _ profileUrl: Data) -> Single<networkingResult>
    {
        return provider.rx.request(.changeInformation(name, introduction, profileUrl))
            .filterSuccessfulStatusCodes()
            .map{_ -> networkingResult in return .ok}
            .catch{ [unowned self] in return .just(setNetworkError($0))}
    }
    
    func setNetworkError(_ error: Error) -> networkingResult {
        print(error)
        print(error.localizedDescription)
        guard let status = (error as? MoyaError)?.response?.statusCode else { return (.fault) }
        return (networkingResult(rawValue: status) ?? .fault)
}
    
}
