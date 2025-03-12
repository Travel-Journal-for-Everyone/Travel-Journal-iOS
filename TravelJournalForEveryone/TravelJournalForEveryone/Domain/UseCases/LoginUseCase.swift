//
//  LoginUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/24/25.
//

import Foundation
import Combine

protocol LoginUseCase {
    func execute(loginProvider: LoginProvider) -> AnyPublisher<String?, Error>
}

final class DefaultLoginUseCase: LoginUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(loginProvider: LoginProvider) -> AnyPublisher<String?, Error> {
        return authRepository.loginWith(loginProvider)
    }
}
