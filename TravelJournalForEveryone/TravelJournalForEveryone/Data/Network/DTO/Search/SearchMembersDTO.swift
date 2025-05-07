//
//  SearchMembersDTO.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/19/25.
//

import Foundation

struct SearchMembersDTO: Decodable {
    let memberID: Int
    let nickname: String
    let profileImageURL: String
    let travelJournalCount: Int
    let placesCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case nickname
        case profileImageURL = "profileImageUrl"
        case travelJournalCount = "travelDiaryCount"
        case placesCount
    }
}

extension SearchMembersDTO: BasePageableContent {
    typealias Entity = UserSummary
    
    func toEntity() -> UserSummary {
        return .init(
            id: memberID,
            profileImageURLString: profileImageURL,
            nickname: nickname,
            travelJournalCount: travelJournalCount,
            placeCount: placesCount
        )
    }
}
