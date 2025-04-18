//
//  FetchPlacesRequest.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/15/25.
//

import Foundation

struct FetchPlacesRequest {
    let memberID: Int
    let regionName: String?
    let pageNumber: Int
    let pageSize: Int
}
