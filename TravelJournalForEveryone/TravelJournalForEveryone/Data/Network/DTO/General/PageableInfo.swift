//
//  PageableInfo.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/14/25.
//

import Foundation

struct PageableInfo: Decodable {
    let pageNumber: Int
    let pageSize: Int
    let sort: SortInfo
    let offset: Int
    let paged: Bool
    let unpaged: Bool
}
