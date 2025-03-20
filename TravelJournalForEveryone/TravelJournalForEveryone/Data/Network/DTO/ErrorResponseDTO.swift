//
//  ErrorResponseDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/14/25.
//

import Foundation

//TODO: 서버의 오류 DTO와 상의하기
struct ErrorResponseDTO: Decodable {
    let message: String
    let success: Bool?
    let status: String?
}
