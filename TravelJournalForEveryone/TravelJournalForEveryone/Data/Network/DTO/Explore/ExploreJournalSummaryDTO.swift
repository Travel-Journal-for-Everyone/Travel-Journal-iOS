//
//  ExploreJournalSummaryDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/18/25.
//

import Foundation

struct ExploreJournalSummaryDTO: Decodable, BasePageableContent {
    typealias Entity = ExploreJournalSummary
    
    let journalID: Int
    let title: String
    let hashtag: [String]
    let address: String
    let nights: Int
    let days: Int
    let startDate: String
    let endDate: String
    let thumbnailURL: String
    let likeCount: Int
    let commentCount: Int
    let memberID: Int
    let nickname: String
    let profileImageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case journalID = "journalId"
        case hashtag = "hashTag"
        case address = "region"
        case title, nights, days, startDate, endDate
        case thumbnailURL = "thumbnailUrl"
        case likeCount, commentCount
        case memberID = "memberId"
        case nickname
        case profileImageURL = "profileImageUrl"
    }
}

extension ExploreJournalSummaryDTO {
    func toEntity() -> Entity {
        return .init(
            id: journalID,
            thumbnailURLString: thumbnailURL,
            profileImageURLString: profileImageURL,
            nickname: nickname,
            hashtag: hashtag,
            title: title,
            startDateString: startDate,
            endDateString: endDate,
            address: address,
            likeCount: likeCount,
            commentCount: commentCount
        )
    }
}
