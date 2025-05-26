//
//  JournalSummaryDTO.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 5/7/25.
//

import Foundation

struct JournalSummaryDTO: Decodable {
    let journalID: Int
    let hashtag: [String]
    let title: String
    let nights: Int
    let days: Int
    let startDate: String
    let endDate: String
    
    private enum CodingKeys: String, CodingKey {
        case journalID = "journalId"
        case hashtag = "hashTag"
        case title, nights, days, startDate, endDate
    }
}

extension JournalSummaryDTO: BasePageableContent {
    typealias Entity = JournalSummary
    
    func toEntity() -> Entity {
        .init(
            id: journalID,
            hashtag: hashtag,
            title: title,
            nights: nights,
            days: days,
            startDateString: startDate,
            endDateString: endDate
        )
    }
}
