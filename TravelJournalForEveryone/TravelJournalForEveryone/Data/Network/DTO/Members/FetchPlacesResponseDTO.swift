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
