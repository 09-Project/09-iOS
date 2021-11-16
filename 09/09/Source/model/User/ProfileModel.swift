//
//  ProfileModel.swift
//  09
//
//  Created by 김기영 on 2021/10/18.
//

import Foundation

struct ProfileModel: Codable {
    var name = String()
    var profile_url = String()
    var introduction = String()
    var all_post_count = Int()
    var get_likes_count = Int()
    var in_progress_postCount = Int()
    var completed_post_count = Int()
    var like_post_count = Int()
    
}
