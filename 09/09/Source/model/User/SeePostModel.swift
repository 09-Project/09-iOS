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
    let price: Int?
    let transaction_region: String
    let open_chat_link: String
    let purpose: String
    let completed: String
    let created_date: String
    let updated_date: String
    let image: String
    let member_info: member_info
    let get_likes: Int
    let liked: Bool
    let mine: Bool
}

struct member_info: Codable {
    let member_id: Int
    let member_name: String
    let member_introduction: String?
    let member_profile: String?
    let posts_count: Int
    let every_like_counts: Int
}
