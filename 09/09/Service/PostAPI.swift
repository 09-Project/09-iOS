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
    
    func seeProducts(_ post_id: Int) -> Observable<networkingResult> {
        request.resultData(.seeProducts(post_id))
            .map{response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    return .ok
                case 404:
                    return .notFound
                default:
                    print(response.statusCode)
                    return .fault
                }
            }
    }
    
    func products() -> Observable<networkingResult> {
        request.resultData(.products)
            .map{response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    return .ok
                case 404:
                    return .notFound
                default:
                    print(response.statusCode)
                    return .fault
                }
            }
    }
    
    func search() -> Observable<networkingResult> {
        request.resultData(.search)
            .map { response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    return .ok
                case 404:
                    return .notFound
                default:
                    print(response.statusCode)
                    return .fault
                }
            }
    }
    
    func other() -> Observable<networkingResult> {
        request.resultData(.other)
            .map { response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    return .ok
                case 404:
                    return .notFound
                default:
                    print(response.statusCode)
                    return .fault
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
    }}
