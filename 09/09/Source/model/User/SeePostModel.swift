//
//  SeePostModel.swift
//  09
//
//  Created by 김기영 on 2021/10/18.
//

import Foundation

struct SeePostModel: Codable {
    let title: String
    let content: String
    let price: Int
    let transactionRegion: String
    let openChatLink: String
    let purpose: String
    let completed: String
    let createdData: String
    let updatedData: String
    let image: String
    let getLikes: Int
    let memberId: Int
    let memberName: String
    let memberIntroduction: String
    let postsCount: Int
    let everyLikeCounts: Int
}

struct SeePostList: Codable {
    var SeePostList: [SeePostModel]
}
