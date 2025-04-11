//
//  UserSummary.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/9/25.
//

import Foundation

struct UserSummary: Hashable {
    let profileImageURLString: String
    let nickname: String
    let travelJournalCount: Int
    let placeCount: Int
}

extension UserSummary {
    static func mock(nickname: String) -> Self {
        .init(
            profileImageURLString: "https://fastly.picsum.photos/id/584/200/300.jpg?hmac=sBfls3kxMp0j0qH3R-K2qM8Wyak1FlpOIgtcd7cEg68",
            nickname: nickname,
            travelJournalCount: 23,
            placeCount: 77
        )
    }
}
