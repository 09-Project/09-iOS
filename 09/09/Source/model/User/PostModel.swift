//
//  LikePostModel.swift
//  09
//
//  Created by 김기영 on 2021/10/18.
//

import Foundation

struct PostModel: Codable {
    let id: Int
    let title: String
    let price: Int
    let transaction_region: String
    let purpose: String
    let completed: String
    let created_date: String
    let updated_date: String
    let image: String
    let liked: Bool
}

struct posts: Codable {
    var count: Int
    var posts: [PostModel]
}
