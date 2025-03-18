//
//  LoginCompleteUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/14/25.
//

import Foundation
import Combine

protocol SignUpUseCase {
    func execute(_ nickname: String, _ visibility: AccountScope) -> AnyPublisher<Bool, NetworkError>
}

struct DefaultLoginCompleteUseCase: SignUpUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(_ nickname: String, _ visibility: AccountScope) -> AnyPublisher<Bool, NetworkError> {
        let request = SignUpRequestDTO(
            nickname: nickname,
            accountScope: visibility
        )
        return userRepository.completeSignUp(request)
    }
}
