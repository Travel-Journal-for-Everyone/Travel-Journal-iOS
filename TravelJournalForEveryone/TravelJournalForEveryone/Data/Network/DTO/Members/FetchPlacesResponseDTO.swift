//
//  FetchPlacesResponseDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/15/25.
//

import Foundation

struct FetchPlacesResponseDTO: Decodable {
    let content: [PlaceSummaryDTO]
    let pageable: PageableDTO
    let totalPages: Int
    let totalElements: Int
    let last: Bool
    let size: Int
    let number: Int
    let sort: SortDTO
    let numberOfElements: Int
    let first: Bool
    let empty: Bool
}

extension FetchPlacesResponseDTO {
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
}

extension FetchPlacesResponseDTO {
    func toEntity() -> Pageable<PlaceSummary> {
        return .init(
            totalContents: totalElements,
            isLast: last,
            pageNumber: number,
            isEmpty: empty,
            contents: content.map { $0.toEntity() }
        )
    }
}

extension FetchPlacesResponseDTO.PlaceSummaryDTO {
    func toEntity() -> PlaceSummary {
        return .init(
            id: id,
            thumbnailURLString: thumbnailURLString,
            name: name,
            address: address
        )
    }
}
