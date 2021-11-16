//
//  OtherModel.swift
//  09
//
//  Created by 김기영 on 2021/10/18.
//

import Foundation

struct OtherModel: Codable {
    let id: Int
    let title: String
    let image: String
    let completed: String
    let liked: Bool
}


struct OtherList: Codable {
    var otherList: [OtherModel]
}
