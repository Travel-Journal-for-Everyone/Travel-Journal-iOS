//
//  NicknameCheckUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/27/25.
//

import Foundation

protocol NicknameCheckUseCase {
    func validateNickname(_ nickname: String) -> NicknameValidationResult
}

enum NicknameValidationResult {
    case valid
    case empty
    case tooShort
    case containsWhitespace
    case invalidCharacters
}

final class DefaultNicknameCheckUseCase: NicknameCheckUseCase {
    func validateNickname(_ nickname: String) -> NicknameValidationResult {
        if nickname.isEmpty {
            return .empty
        }
        
        if nickname.contains(where: { $0.isWhitespace }) {
            return .containsWhitespace
        }
        
        let regex = "^[가-힣a-zA-Z0-9]+$" // 한글, 영문, 숫자만 허용
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        if !predicate.evaluate(with: nickname) {
            return .invalidCharacters
        }
        
        if nickname.count < 2 {
            return .tooShort
        }
        
        return .valid
    }
}
