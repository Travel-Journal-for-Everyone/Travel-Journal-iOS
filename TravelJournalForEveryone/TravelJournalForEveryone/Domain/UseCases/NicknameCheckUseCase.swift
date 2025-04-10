//
//  NicknameCheckUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/27/25.
//

import Foundation
import Combine

protocol NicknameCheckUseCase {
    func validateNicknameByRegex(_ nickname: String) -> NicknameRegexCheckResult
    func validateNicknameByServer(_ nickname: String) -> AnyPublisher<NicknameServerCheckResult, NetworkError>
}

final class DefaultNicknameCheckUseCase: NicknameCheckUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func validateNicknameByRegex(_ nickname: String) -> NicknameRegexCheckResult {
        if nickname.isEmpty {
            return .initial
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
    
    func validateNicknameByServer(_ nickname: String) -> AnyPublisher<NicknameServerCheckResult, NetworkError> {
        return userRepository.validateNickname(nickname)
            .map { NicknameServerCheckResult.from(response: $0) }
            .eraseToAnyPublisher()
    }
}
