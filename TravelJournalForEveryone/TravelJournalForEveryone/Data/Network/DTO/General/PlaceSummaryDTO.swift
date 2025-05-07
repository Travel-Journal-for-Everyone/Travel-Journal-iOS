//
//  PlaceSummaryDTO.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 5/7/25.
//

import Foundation

struct PlaceSummaryDTO: Decodable {
    let id: Int
    let thumbnailURLString: String
    let name: String
    let address: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "placeId"
        case thumbnailURLString = "thumbnailUrl"
        case name = "title"
        case address = "region"
    }
}

extension PlaceSummaryDTO: BasePageableContent {
    typealias Entity = PlaceSummary
    
    func toEntity() -> PlaceSummary {
        return .init(
            id: id,
            thumbnailURLString: thumbnailURLString,
            name: name,
            address: address
        )
    }
}
