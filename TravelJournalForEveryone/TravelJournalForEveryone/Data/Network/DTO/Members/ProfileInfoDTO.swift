//
//  ProfileInfoDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/27/25.
//

import Foundation

struct ProfileInfoDTO: Decodable {
    let nickname: String
    let profileImageURL: String
    let accountScope: String
    let followingCount: Int
    let followerCount: Int
    let travelJournalCount: Int
    let placesCount: Int
    let isFirstLogin: Bool
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case profileImageURL = "profileImageUrl"
        case accountScope
        case followingCount
        case followerCount
        case travelJournalCount = "travelDiaryCount"
        case placesCount
        case isFirstLogin
    }
}
