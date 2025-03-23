//
//  LoginCompleteUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/14/25.
//

import Foundation
import Combine

protocol SignUpUseCase {
    func execute(
        nickname: String,
        accountScope: AccountScope
    ) -> AnyPublisher<Bool, NetworkError>
}

struct DefaultLoginCompleteUseCase: SignUpUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(
        nickname: String,
        accountScope: AccountScope
    ) -> AnyPublisher<Bool, NetworkError> {
        let request = SignUpRequestDTO(
            nickname: nickname,
            accountScope: accountScope
        )
        return userRepository.completeSignUp(request)
    }
}
