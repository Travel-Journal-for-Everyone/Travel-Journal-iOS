//
//  Pageable.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/15/25.
//

import Foundation

struct Pageable<Content> {
    let totalContents: Int
    let isLast: Bool
    let pageNumber: Int
    let isEmpty: Bool
    let contents: [Content]
}
