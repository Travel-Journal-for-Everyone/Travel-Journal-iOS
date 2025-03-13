//
//  RefreshJWTTokenResponseDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/13/25.
//

import Foundation

struct RefreshJWTTokenResponseDTO: Decodable, Sendable {
    let refreshToken: String
}
