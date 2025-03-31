//
//  RegionDataDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/27/25.
//

import Foundation

struct RegionDataDTO: Decodable {
    let regionName: String
    let travelJournalCount: Int
    let placesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case regionName
        case travelJournalCount = "travelDiaryCount"
        case placesCount
    }
}

extension RegionDataDTO {
    func toEntity() -> RegionData {
        return RegionData(
            regionName: Region.from(response: regionName),
            travelJournalCount: travelJournalCount,
            placesCount: placesCount
        )
    }
}
