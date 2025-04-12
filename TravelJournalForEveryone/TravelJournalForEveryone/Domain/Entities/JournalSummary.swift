//
//  JournalSummary.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/8/25.
//

import Foundation

struct JournalSummary: Identifiable {
    let id: Int
    let hashtag: [String]
    let title: String
    let nights: Int
    let days: Int
    let startDateString: String
    let endDateString: String
}

extension JournalSummary {
    static func mock(id: Int, title: String) -> Self {
        return .init(
            id: id,
            hashtag: ["부산", "해변", "해안욕장"],
            title: title,
            nights: 2,
            days: 3,
            startDateString: "2025.04.07",
            endDateString: "2025.04.09"
        )
    }
}

struct JournalsPage {
    let totalJournals: Int
    let isLast: Bool
    let pageNumber: Int
    let isEmpty: Bool
    let journalSummaries: [JournalSummary]
}
