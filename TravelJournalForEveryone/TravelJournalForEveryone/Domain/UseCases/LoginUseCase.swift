//
//  LoginUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/24/25.
//

import Foundation
import Combine

protocol LoginUseCase {
    func loginWith(_ loginType: LoginType) -> AnyPublisher<String, LoginError>
}

enum LoginError: Error {
    case kakaologinFailed
    case appleLoginFailed
    case googleLoginFailed
    case unknown
}

final class DefaultLoginUseCase: LoginUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func loginWith(_ loginType: LoginType) -> AnyPublisher<String, LoginError> {
        switch loginType {
        case .kakao:
            return authRepository.loginWithKakao()
        case .apple:
            return Empty().eraseToAnyPublisher()
        case .google:
            return Empty().eraseToAnyPublisher()
        }
    }
}
