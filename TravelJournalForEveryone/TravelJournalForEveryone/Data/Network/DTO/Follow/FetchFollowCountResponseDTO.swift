//
//  FetchFollowCountResponseDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/23/25.
//

import Foundation

struct FetchFollowCountResponseDTO: Decodable {
    let followers: Int
    let followings: Int
}

extension FetchFollowCountResponseDTO {
    func toEntity() -> FollowCountInfo {
        return .init(
            followers: followers,
            followings: followings
        )
    }
}
