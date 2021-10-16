//
//  LikeAPI.swift
//  09
//
//  Created by 김기영 on 2021/10/16.
//

import Foundation
import RxSwift
import RxCocoa

class LikeAPI {
    let baseURL = "http://3.36.26.221:8080"
    let request = ServiceType()
    
    func like(_ postID: Int) -> Observable<networkingResult> {
        request.resultData(.likeObj(postID))
            .map{response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode {
                case 201:
                    return .ok
                case 400:
                    return .wrongRq
                case 401:
                    return .tokenError
                case 404:
                    return .notFound
                case 409:
                    return .conflict
                default:
                    print(response.statusCode)
                    return .fault
                }
            }
                 
    }
    
    func deleteLike(_ postId: Int) -> Observable<networkingResult> {
        request.resultData(.deleteLike(postId))
            .map { response, data -> networkingResult in
                print(response.statusCode)
                switch response.statusCode {
                case 204:
                    return .deleteOk
                case 401:
                    return .wrongRq
                case 404:
                    return .notFound
                default:
                    print(response.statusCode)
                    return .fault
                }
            }
    }
}
