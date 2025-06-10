//
//  BlockedUserDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/28/25.
//

import Foundation

struct BlockedUserDTO: Decodable {
    let memberID: Int
    let nickname: String
    let profileImageURLString: String
    
    private enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case nickname
        case profileImageURLString = "profileImageUrl"
    }
}

extension BlockedUserDTO: BasePageableContent {
    typealias Entity = UserSummary
    
    func toEntity() -> Entity {
        return .init(
            id: memberID,
            profileImageURLString: profileImageURLString,
            nickname: nickname,
            travelJournalCount: nil,
            placeCount: nil
        )
    }
}
