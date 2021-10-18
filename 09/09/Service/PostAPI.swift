//
//  PostAPI.swift
//  09
//
//  Created by 김기영 on 2021/10/16.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import SideMenu

class PostAPI {
    let baseURL = "http://3.36.26.221:8080"
    let request = ServiceType()
    
    func delete(_ post_id: Int) -> Observable<networkingResult> {
        request.resultData(.deleteProducts(post_id))
            .map{ response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode {
                case 204:
                    return .deleteOk
                case 400:
                    return .wrongRq
                case 401:
                    return .tokenError
                case 404:
                    return .notFound
                default:
                    print(response.statusCode)
                    return .fault
                }
            }
    }
    
    func seeProducts(_ post_id: Int) -> Observable<([SeePostModel]?, networkingResult)> {
        request.resultData(.seeProducts(post_id))
            .map{response, data -> ([SeePostModel]?, networkingResult) in
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode([SeePostModel].self, from: data)
                    else {return (nil, .fault)}
                    
                    return (data, .ok)
                case 404:
                    return (nil, .notFound)
                default:
                    print(response.statusCode)
                    return (nil, .fault)
                }
            }
    }
    
    func products(page: Int, size: Int) -> Observable<([PostModel]?,networkingResult)> {
        request.resultData(.products(page, size))
            .map{response, data -> ([PostModel]?, networkingResult) in
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode([PostModel]?.self, from: data) else
                    { return (nil, .fault)}
                    
                    return (data, .ok)
                case 404:
                    return (nil, .notFound)
                default:
                    print(response.statusCode)
                    return (nil, .fault)
                }
            }
    }
    
    func search(keywords: String, page: Int, size: Int) -> Observable<([PostModel]?,
    networkingResult)> {
        request.resultData(.search(keywords, page, size))
            .map { response, data -> ([PostModel]?, networkingResult) in
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode([PostModel].self, from: data) else {
                        return (nil, .fault)
                    }
                    
                    return (data, .ok)
                case 404:
                    return (nil, .notFound)
                default:
                    print(response.statusCode)
                    return (nil, .fault)
                }
            }
    }
    
    func other() -> Observable<([OtherModel]?, networkingResult)> {
        request.resultData(.other)
            .map { response, data -> ([OtherModel]?, networkingResult) in
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode([OtherModel].self, from: data) else {
                        return (nil, .fault)
                    }
                    return (data, .ok)
                case 404:
                    return (nil, .notFound)
                default:
                    print(response.statusCode)
                    return (nil, .fault)
                }
            }
    }
    
    func pathProducts(post_id: Int, title: String, content: String,price: Int,
                      transactionRegion: String, openChatLink: String, image: String) -> Observable<networkingResult> {
        request.resultData(.putProducts(post_id, title, content, price, transactionRegion,
                                        openChatLink, image))
            .map{ response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode {
                case 204:
                    return .deleteOk
                case 400:
                    return .wrongRq
                case 401:
                    return .tokenError
                case 404:
                    return .notFound
                default:
                    print(response.statusCode)
                    return .fault
                    
                }
            }
    }
    
    func post(title: String, content: String, price: Int, transactionRegion: String,
              openChatLink: String, image: String) -> Observable<networkingResult> {
        request.resultData(.postProducts(title, content, price, transactionRegion,
                                         openChatLink, image))
            .map { response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode{
                case 201:
                    return .okay
                case 400:
                    return .wrongRq
                case 401:
                    return .tokenError
                case 404:
                    return .notFound
                default:
                    print(response.statusCode)
                    return .fault
                }
            }
    }
    
    func end(_ post_id: Int) -> Observable<networkingResult> {
        request.resultData(.end(post_id))
            .map{response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode {
                case 201:
                    return .okay
                case 400:
                    return .wrongRq
                case 401:
                    return .tokenError
                case 404:
                    return .notFound
                default:
                    print(response.statusCode)
                    return .fault
                }
            }
    }
    
    func seeLikePost() -> Observable<([PostModel]?, networkingResult)> {
        request.resultData(.seeLikePost)
            .map{ response, data -> ([PostModel]?, networkingResult) in
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode([PostModel]?.self, from: data)
                    else {return (nil, .fault)}
                    return (data, .ok)
                case 400:
                    return (nil, .wrongRq)
                case 401:
                    return (nil, .tokenError)
                case 404:
                    return (nil, .notFound)
                default:
                    print(response.statusCode)
                    return (nil, .fault)
                }
            }
    }
}
