//
//  ProfileModel.swift
//  09
//
//  Created by 김기영 on 2021/10/18.
//

import Foundation

struct ProfileModel: Codable {
    let member_id: Int
    let name: String
    let profile_url: String?
    let introduction: String?
    let all_posts_count: Int
    let get_likes_count: Int
    let in_progress_posts_count: Int
    let completed_posts_count: Int
    let like_posts_count: Int
}
