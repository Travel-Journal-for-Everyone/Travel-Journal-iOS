//
//  SearchPlacesDTO.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 5/7/25.
//

import Foundation

struct SearchPlacesDTO: Decodable {
    let placeId: Int
    let title: String
    let region: String
    let thumbnailUrl: String
}

extension SearchPlacesDTO: BasePageableContent {
    typealias Entity = PlaceSummary
    
    func toEntity() -> PlaceSummary {
        return .init(
            id: placeId,
            thumbnailURLString: thumbnailUrl,
            name: title,
            address: region
        )
    }
}
