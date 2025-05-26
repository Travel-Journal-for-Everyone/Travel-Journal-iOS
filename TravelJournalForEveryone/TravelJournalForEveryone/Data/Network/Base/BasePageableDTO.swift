//
//  BasePageableDTO.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 5/7/25.
//

import Foundation


protocol BasePageableContent {
    associatedtype Entity
    func toEntity() -> Entity
}

struct BasePageableDTO<T: Decodable & BasePageableContent & Sendable>: Decodable {
    let content: [T]
    let pageable: PageableDTO
    let totalPages: Int
    let totalElements: Int
    let last: Bool
    let size: Int
    let number: Int
    let first: Bool
    let empty: Bool
}

extension BasePageableDTO {
    func toEntity() -> Pageable<T.Entity> {
        return .init(
            totalContents: totalElements,
            isLast: last,
            pageNumber: number,
            isEmpty: empty,
            contents: content.map { $0.toEntity() }
        )
    }
}
