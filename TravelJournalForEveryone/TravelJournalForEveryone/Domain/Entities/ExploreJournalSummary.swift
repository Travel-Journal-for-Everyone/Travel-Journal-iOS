//
//  ExploreJournalSummary.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/1/25.
//

import Foundation

struct ExploreJournalSummary: Identifiable {
    let id: Int
    
    let thumbnailURLString: String
    let profileImageURLString: String
    let nickname: String
    let hashtag: [String]
    let title: String
    let startDateString: String
    let endDateString: String
    let address: String
    
    let likeCount: Int
    let commentCount: Int
}

extension ExploreJournalSummary {
    static func mock(id: Int, title: String) -> Self {
        return .init(
            id: id,
            thumbnailURLString: "https://fastly.picsum.photos/id/584/200/300.jpg?hmac=sBfls3kxMp0j0qH3R-K2qM8Wyak1FlpOIgtcd7cEg68",
            profileImageURLString: "https://fastly.picsum.photos/id/584/200/300.jpg?hmac=sBfls3kxMp0j0qH3R-K2qM8Wyak1FlpOIgtcd7cEg68",
            nickname: "쿨쿨띠",
            hashtag: ["부산", "해변", "해안욕장"],
            title: title,
            startDateString: "2025.04.07",
            endDateString: "2025.04.09",
            address: "부산광역시 남구 용호3동 이기대공원로 105-20",
            likeCount: 20,
            commentCount: 8
        )
    }
}
