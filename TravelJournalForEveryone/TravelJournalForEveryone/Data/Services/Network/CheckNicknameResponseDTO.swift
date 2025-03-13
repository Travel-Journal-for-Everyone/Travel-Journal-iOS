//
//  CheckNicknameResponseDTO.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/11/25.
//

import Foundation

struct CheckNicknameResponseDTO: Decodable {
    let success: Bool
    let message: String
    let data: String?
}
