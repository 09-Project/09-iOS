//
//  UserAPI.swift
//  09
//
//  Created by 김기영 on 2021/10/16.
//

import Foundation
import RxSwift
import RxCocoa

class UserAPI {
    let baseURL = "http://3.36.26.221:8080"
    let request = ServiceType()
    
    func getInformation() -> Observable<(InformationModel?, networkingResult)> {
        request.resultData(.getInformation)
            .map{response, data -> (InformationModel?, networkingResult) in
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(InformationModel.self, from: data)
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
    
    func profile(_ memberID: Int) -> Observable<(ProfileModel?,networkingResult)> {
        request.resultData(.profile(memberID))
            .map {response, data -> (ProfileModel?, networkingResult) in
                print(response.statusCode)
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(ProfileModel?.self, from: data)
                    else { return (nil, .fault) }
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
