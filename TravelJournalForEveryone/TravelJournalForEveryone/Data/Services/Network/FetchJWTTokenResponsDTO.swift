//
//  FetchJWTTokenResponsDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/12/25.
//

import Foundation

struct FetchJWTTokenResponsDTO: Decodable, Sendable {
    let memberID: Int
    let isFirstLogin: Bool
    let refreshToken: String
    let deviceID: String

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case isFirstLogin, refreshToken
        case deviceID = "deviceId"
    }
}
