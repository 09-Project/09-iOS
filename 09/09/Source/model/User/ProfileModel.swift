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
    
    init(name: String, profileUrl: String, introduction: String, allPostCount: Int,
         getLikesCount: Int, inProgressPostCount: Int, completedPostCount: Int, likePostCount:Int)
    {
        self.name = name
        self.profileUrl = profileUrl
        self.introduction = introduction
        self.allPostCount = allPostCount
        self.getLikesCount = getLikesCount
        self.inProgressPostCount = inProgressPostCount
        self.completedPostCount = completedPostCount
        self.likePostCount = likePostCount
    }
    
}
