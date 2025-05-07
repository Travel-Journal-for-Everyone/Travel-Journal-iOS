//
//  FetchJournalsResponseDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/12/25.
//

import Foundation

struct FetchJournalsResponseDTO: Decodable {
    let content: [JournalSummaryDTO]
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

extension FetchJournalsResponseDTO {
    func toEntity() -> Pageable<JournalSummary> {
        return .init(
            totalContents: totalElements,
            isLast: last,
            pageNumber: number,
            isEmpty: empty,
            contents: content.map { $0.toEntity() }
        )
    }
}
