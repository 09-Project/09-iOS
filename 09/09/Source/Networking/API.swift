//
//  File.swift
//  09
//
//  Created by 김기영 on 2021/09/10.
//

import Foundation
import Moya

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
    case changeInformation(_ name: String, _ introduction: String, _ profileURL: Data)
    case myPage
    
    // Post
    case deleteProducts(_ postID: Int)
    case seeProducts(_ postID: Int)
    case products(_ page: Int)
    case search(_ keywords: String, _ page: Int)
    case other
    case putProducts(_ postID: Int, _ title: String, _ content: String, _ price: Int,
                     _ transactionRegion: String, _ openChatLink: String, _ image: Data)
    case postProducts(_ title: String, _ content: String, _ price: Int, _ transactionRegion: String,
                      _ openChatLink: String, _ image: Data)
    case end(_ postID: Int)
    case seeLikePost
    case seeDeletePost(_ member_Id: Int)
    
}

extension API: TargetType {
    var baseURL: URL {
        URL(string: "http://3.36.26.221:8080")!
    }
    
    var path: String {
        switch self {
        case .signIn:
            return "/auth/login"
        case .signUp:
            return "/auth/signup"
        case .refreshToken:
            return "/auth/reissue"
        case .changepw:
            return "/member/password"
        case .getInformation:
            return "/member/information"
        case .profile(let id):
            return "/memeber/\(id)"
        case .changeInformation:
            return "/member/information"
        case .deleteProducts(let id):
            return "/post/\(id)"
        case .seeProducts(let id):
            print("path")
            return "/post/\(id)"
        case .products:
            return "/post"
        case .search:
            return "/post/search"
        case .other:
            return "/post/other"
        case .putProducts(let id):
            return "/post/\(id)"
        case .postProducts:
            print("hello")
            return "/post"
        case .end(let id):
            return "/post/\(id)"
        case .likeObj(let id):
            return "/like/\(id)"
        case .deleteLike(let id):
            return "/like/\(id)"
        case .seeLikePost:
            return "/member/like"
        case .seeDeletePost(let id):
            return "/member/completed/\(id)"
        case .myPage:
            return "/member/my-page"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .likeObj, .signUp, .signIn, .postProducts:
            return .post
        case .profile, .seeLikePost,.getInformation, .seeProducts, .products, .other, .search, .seeDeletePost, .myPage:
            print("get")
            return .get
        case .putProducts, .changepw, .changeInformation:
            return .patch
        case .deleteProducts, .deleteLike:
            return .delete
        case .refreshToken, .end:
            return .put
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .signIn, .signUp:
            return ["Content-Type" : "application/json"]
        case .refreshToken:
            guard let refreshToken = Token.refreshToken else {return ["Content-Type" : "application/json"]}
            return ["X-Refresh-Token" : refreshToken]
            
        case .postProducts, .putProducts, .changeInformation:
            guard let token = Token.accessToken else {return ["Content-Type" : "application/json"]}
            return ["Authorization" : "Bearer " + token, "Content-Type" : "multipart/form-data"]
            
        default:
            print("header")
            guard let token = Token.accessToken else {return ["Content-Type" : "application/json"]}
            return ["Authorization" : "Bearer " + token]
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postProducts(let title, let content, let price, let transactionRegion,
                           let openChatLink, let image):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .data(image), name: "image", fileName: "image.jpg"))
            multipartFormData.append(MultipartFormData(provider: .data(title.data(using: .utf8)!), name: "title", mimeType: "text/plain"))
            multipartFormData.append(MultipartFormData(provider: .data(content.data(using: .utf8)!), name: "content", mimeType: "text/plain"))
            multipartFormData.append(MultipartFormData(provider: .data(price.description.data(using: .utf8)!), name: "price", mimeType: "text/plain"))
            multipartFormData.append(MultipartFormData(provider: .data(transactionRegion.data(using: .utf8)!), name: "transaction_region", mimeType: "text/plain"))
            multipartFormData.append(MultipartFormData(provider: .data(openChatLink.data(using: .utf8)!), name: "open_chat_link", mimeType: "text/plain"))
            return .uploadMultipart(multipartFormData)
            
        case .changeInformation(let name, let introduce, let profileUrl):
            var multipartFormData = [MultipartFormData]()
            
            multipartFormData.append(MultipartFormData(provider: .data(name.data(using: .utf8)!), name: "name", mimeType: "text/plain"))
            multipartFormData.append(MultipartFormData(provider: .data(introduce.data(using: .utf8)!), name: "introduction", mimeType: "text/plain"))
            multipartFormData.append(MultipartFormData(provider: .data(profileUrl), name: "profileUrl", fileName: "profileUrl.jpg", mimeType: "profileUrl/jpg"))
            
            return .uploadMultipart(multipartFormData)
            
        case .signIn(let username, let password):
            return .requestParameters(parameters: ["username": username, "password": password],
                                      encoding: JSONEncoding.prettyPrinted)
            
        case .signUp(let name, let username, let password):
            return .requestParameters(parameters: ["name": name, "username": username,
                                                   "password": password],
                                      encoding: JSONEncoding.prettyPrinted)
            
        case .changepw(let password, let new_password):
            return .requestParameters(parameters: ["password": password,
                                                   "new_password": new_password],
                                      encoding: JSONEncoding.prettyPrinted)
            
        case .putProducts(let postID, let title, let content, let price, let transactionRegion,
                          let openChatLink, let image):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .data(postID.description.data(using: .utf8)!), name: "postID", mimeType: "text/plain"))
            multipartFormData.append(MultipartFormData(provider: .data(image), name: "image", fileName: "image.jpg", mimeType: "image/jpg"))
            multipartFormData.append(MultipartFormData(provider: .data(title.data(using: .utf8)!), name: "title", mimeType: "text/plain"))
            multipartFormData.append(MultipartFormData(provider: .data(content.data(using: .utf8)!), name: "content", mimeType: "text/plain"))
            multipartFormData.append(MultipartFormData(provider: .data(price.description.data(using: .utf8)!), name: "price", mimeType: "text/plain"))
            multipartFormData.append(MultipartFormData(provider: .data(transactionRegion.data(using: .utf8)!), name: "transaction_region", mimeType: "text/plain"))
            multipartFormData.append(MultipartFormData(provider: .data(openChatLink.data(using: .utf8)!), name: "open_chat_link", mimeType: "text/plain"))
            
            return .uploadMultipart(multipartFormData)
            
        case .search(let keyword, let page):
            return .requestParameters(parameters: ["keyword" : keyword, "page" : page], encoding: URLEncoding.queryString)
            
        case .products(let page):
            return .requestParameters(parameters: ["page" : page], encoding: URLEncoding.queryString)
            
        default:
            return .requestPlain
        }
    }
}
