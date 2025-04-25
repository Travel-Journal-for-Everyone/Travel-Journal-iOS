//
//  SearchMembersResponseDTO.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/19/25.
//

import Foundation

struct SearchMembersResponseDTO: Decodable {
    let content: [MemberDTO]
    let pageable: PageableDTO
    let totalPages: Int
    let totalElements: Int
    let last: Bool
    let size: Int
    let number: Int
    let first: Bool
    let empty: Bool
}

extension SearchMembersResponseDTO {
    struct MemberDTO: Decodable {
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
}

extension SearchMembersResponseDTO {
    func toEntity() -> Pageable<UserSummary> {
        return .init(
            totalContents: totalElements,
            isLast: last,
            pageNumber: number,
            isEmpty: empty,
            contents: content.map { $0.toEntity() }
        )
    }
}

extension SearchMembersResponseDTO.MemberDTO {
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
