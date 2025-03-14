//
//  ErrorResponseDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/14/25.
//

import Foundation

struct ErrorResponseDTO: Decodable {
    let message: String
    let status: String
}
