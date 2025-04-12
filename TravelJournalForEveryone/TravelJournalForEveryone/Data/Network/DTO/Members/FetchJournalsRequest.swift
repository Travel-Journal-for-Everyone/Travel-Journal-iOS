//
//  FetchJournalsRequest.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/12/25.
//

import Foundation

struct FetchJournalsRequest {
    let memberID: Int
    let regionName: String
    let pageNumber: Int
    let pageSize: Int
}
