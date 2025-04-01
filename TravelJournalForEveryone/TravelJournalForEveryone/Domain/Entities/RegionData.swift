//
//  RegionData.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/27/25.
//

import Foundation

struct RegionData {
    let regionName: Region
    let travelJournalCount: Int
    let placesCount: Int
}

extension RegionData {
    static func mock(_ region: Region) -> RegionData {
        return RegionData(
            regionName: region,
            travelJournalCount: 2,
            placesCount: 5
        )
    }
}
