//
//  File.swift
//  09
//
//  Created by 김기영 on 2021/09/10.
//

import Foundation
import Alamofire

enum API {
    // Auth
    case signUp(_ name: String, _ username: String, _ password: String)
    case signIn(_ username: String, _ password: String)
    case refreshToken
    case changepw(_ password: String, _ new_password: String)
    
    // Like
    case likeObj(_ postID: Int)
    case deleteLike(_ postID: Int)
    
    // User
    case getInformation
    case profile(_ memberID: Int)
    case changeInformation(_ name: String, _ introduction: String, _ profileURL: String)
    case myPage
    
    // Post
    case deleteProducts(_ postID: Int)
    case seeProducts(_ postID: Int)
    case products
    case search
    case other
    case putProducts(_ postID: Int, _ title: String, _ content: String, _ price: Int,
                     _ transactionRegion: String, _ openChatLink: String, _ image: String)
    case postProducts(_ title: String, _ content: String, _ price: Int, _ transactionRegion: String,
                      _ openChatLink: String, _ image: String)
    case end(_ postID: Int)
    
    func path() -> String {
        switch self {
        case .signIn:
            return "/member/auth/login"
        case .signUp:
            return "/member/auth/signup"
        case .refreshToken:
            return "/member/auth/reissue"
        case .changepw:
            return "/member/password"
        case .getInformation:
            return "/member/information"
        case .profile(let id):
            return "/memeber/{\(id)}"
        case .changeInformation:
            return "/member/information"
        case .myPage:
            return "/member/me"
        case .deleteProducts(let id):
            return "/post/{\(id)}"
        case .seeProducts(let id):
            return "/post/{\(id)}"
        case .products:
            return "/post"
        case .search:
            return "/post/search"
        case .other:
            return "/post/other"
        case .putProducts(let id):
            return "/post/{\(id)}"
        case .postProducts:
            return "/post"
        case .end(let id):
            return "/post/{\(id)}"
        case .likeObj(let id):
            return "/like/{\(id)}"
        case .deleteLike(let id):
            return "/like/{\(id)}"
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .likeObj, .signUp, .signIn, .postProducts:
            return .post
        case .profile, .getInformation, .myPage, .seeProducts, .products, .other, .search:
            return .get
        case .putProducts, .changepw, .changeInformation:
            return .patch
        case .deleteProducts, .deleteLike:
            return .delete
        case .refreshToken, .end:
            return .put
        }
    }
    
    func header() -> HTTPHeaders? {
        switch self {
        case .signIn, .signUp:
            return nil
        case .refreshToken:
            guard let token = Token.refreshToken else {return [:]}
                    return ["Authorization" : token]
            
        default:
            guard let token = Token.token else {return [:]}
            return ["Authorization" : "Bearer" + token]
        }
    }
    
    var param: Parameters? {
        switch self {
        case .postProducts(let title, let content, let price, let transactionRegion,
                           let openChatLink, let image):
            return ["title": title, "content": content, "price": price,
                    "transactionRegion": transactionRegion, "openChatLink": openChatLink,
                    "image": image]
        case .signIn(let username, let password):
            return ["username": username, "password": password]
        case .signUp(let name, let username, let password):
            return ["name": name, "username": username, "password": password]
        case .changepw(let password, let new_password):
            return ["password": password, "new_password": new_password]
        case .changeInformation(let name, let introduction, let profileURL):
            return ["name": name, "introduction": introduction, "profileUrl": profileURL]
        case .putProducts(let postID, let title, let content, let price, let transactionRegion,
                            let openChatLink, let image):
            return ["title": title, "content": content, "price": price,
                    "transactionRegion": transactionRegion, "openChatLink": openChatLink,
                    "image": image]
        default:
            return nil
        }
    }
}
