//
//  PageableDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/14/25.
//

import Foundation

struct PageableDTO: Decodable {
    let pageNumber: Int
    let pageSize: Int
    let sort: SortDTO
    let offset: Int
    let paged: Bool
    let unpaged: Bool
}
