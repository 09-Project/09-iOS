//
//  ProfileModel.swift
//  09
//
//  Created by 김기영 on 2021/10/18.
//

import Foundation

struct ProfileModel: Codable {
    var name = String()
    var profileUrl = String()
    var introduction = String()
    var allPostCount = Int()
    var getLikesCount = Int()
    var inProgressPostCount = Int()
    var completedPostCount = Int()
    var likePostCount = Int()
    
}
