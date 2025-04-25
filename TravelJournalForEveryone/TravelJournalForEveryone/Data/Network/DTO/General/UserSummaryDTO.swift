//
//  UserSummaryDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/23/25.
//

import Foundation

struct UserSummaryDTO: Decodable {
    let id: Int
    let profileImageURLString: String
    let nickname: String
    let travelJournalCount: Int
    let placeCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "memberId"
        case profileImageURLString = "profileImageUrl"
        case nickname
        case travelJournalCount = "travelDiaryCount"
        case placeCount = "placesCount"
    }
}

extension UserSummaryDTO {
    func toEntity() -> UserSummary {
        return .init(
            id: id,
            profileImageURLString: profileImageURLString,
            nickname: nickname,
            travelJournalCount: travelJournalCount,
            placeCount: placeCount
        )
    }
}
