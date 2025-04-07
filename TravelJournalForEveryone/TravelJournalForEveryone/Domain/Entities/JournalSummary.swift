//
//  JournalSummary.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/8/25.
//

import Foundation

struct JournalSummary {
    let hashtag: [String]
    let title: String
    let nights: Int
    let days: Int
    let startDateString: String
    let endDateString: String
}

extension JournalSummary {
    static func mock(title: String) -> Self {
        return .init(
            hashtag: ["부산", "해변", "해안욕장"],
            title: title,
            nights: 2,
            days: 3,
            startDateString: "2025.04.07",
            endDateString: "2025.04.09"
        )
    }
}
