//
//  NicknameValidationResult.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/28/25.
//

import Foundation

enum NicknameServerCheckResult {
    case initial
    case valid
    case containsBadWord
    case duplicate
    case unknownStringCode
    case changed
    
    static func from(response: String) -> Self {
        switch response {
        case "valid": .valid
        case "containsBadWord": .containsBadWord
        case "duplicate": .duplicate
        default: .unknownStringCode
        }
    }
}
