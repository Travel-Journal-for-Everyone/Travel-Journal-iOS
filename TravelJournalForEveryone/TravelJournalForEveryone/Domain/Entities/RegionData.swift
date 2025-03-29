//
//  RegionData.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/27/25.
//

import Foundation

struct RegionData {
    let regionName: String
    let travelJournalCount: Int
    let placesCount: Int
}

extension RegionData {
    static func mock() -> RegionData {
        return RegionData(
            regionName: "제주도",
            travelJournalCount: 2,
            placesCount: 5
        )
    }
}
