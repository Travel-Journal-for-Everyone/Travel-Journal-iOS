//
// SignUpResponseDTO.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/14/25.
//

import Foundation

struct SignUpResponseDTO: Decodable {
    let data: String?
    let success: Bool
    let message: String
}
