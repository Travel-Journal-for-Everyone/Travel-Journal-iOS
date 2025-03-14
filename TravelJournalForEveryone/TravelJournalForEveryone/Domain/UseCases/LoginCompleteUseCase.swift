//
//  LoginCompleteUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/14/25.
//

import Foundation
import Combine

protocol LoginCompleteUseCase {
    func postFirstLoginData(_ nickname: String, _ visibility: ProfileVisibilityScope) -> AnyPublisher<Bool, Error>
}

struct DefaultLoginCompleteUseCase: LoginCompleteUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func postFirstLoginData(_ nickname: String, _ visibility: ProfileVisibilityScope) -> AnyPublisher<Bool, any Error> {
        let request = CompleteFirstLoginRequestDTO(
            nickname: nickname,
            accountScope: visibility
        )
        return userRepository.completeFirstLogin(request)
    }
}
