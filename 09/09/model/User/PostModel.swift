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
    let transactionRegion: String
    let purpose: String
    let completed: String
    let createdData: String
    let updatedData: String
    let image: String
}

struct PostList: Codable {
    var PostList: [PostModel]
}
