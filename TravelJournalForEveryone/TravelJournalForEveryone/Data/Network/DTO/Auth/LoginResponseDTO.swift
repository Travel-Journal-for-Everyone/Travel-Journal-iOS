//
//  LoginResponseDTO.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/12/25.
//

import Foundation

struct LoginResponseDTO: Decodable, Sendable {
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

extension LoginResponseDTO {
    func toEntity() -> LoginInfo {
        return LoginInfo(
            memberID: memberID,
            isFirstLogin: isFirstLogin,
            refreshToken: refreshToken,
            deviceID: deviceID
        )
    }
}
