//
//  User.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/15/25.
//

import Foundation

struct User {
    let nickname: String
    let profileImageURLString: String
    let accountScope: AccountScope
    let followingCount: Int
    let followerCount: Int
    let travelJournalCount: Int
    let placesCount: Int
    let isFirstLogin: Bool
    let regionDatas: [RegionData]
}

extension User {
    static func mock() -> User {
        return User(
            nickname: "마루김마루",
            profileImageURLString: "",
            accountScope: .privateProfile,
            followingCount: 1,
            followerCount: 99,
            travelJournalCount: 15,
            placesCount: 25,
            isFirstLogin: false,
            regionDatas: [
                .mock(.metropolitan),
                .mock(.gangwon),
                .mock(.chungcheong),
                .mock(.gyeongsang),
                .mock(.jeolla),
                .mock(.jeju)
            ]
        )
    }
}
