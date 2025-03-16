//
//  AuthStateCheckUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/15/25.
//

import Foundation
import Combine

protocol AuthStateCheckUseCase {
    func execute() -> AnyPublisher<AuthenticationState, Never>
}

struct DefaultAuthStateCheckUseCase: AuthStateCheckUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute() -> AnyPublisher<AuthenticationState, Never> {
        if hasJWTTokenInKeychain() {
            return isValidJWTToken()
                .flatMap { isValid in
                    isValid ?
                    Just(AuthenticationState.authenticated) :
                    Just(AuthenticationState.unauthenticated)
                }
                .eraseToAnyPublisher()
        } else {
            return Just(AuthenticationState.unauthenticated)
                .eraseToAnyPublisher()
        }
    }
    
    private func hasJWTTokenInKeychain() -> Bool {
        guard let _ = KeychainManager.load(forAccount: .accessToken),
              let _ = KeychainManager.load(forAccount: .refreshToken)
        else {
            return false
        }
        return true
    }
    
    private func isValidJWTToken() -> AnyPublisher<Bool, Never> {
        // TODO: - 
        // 유저디폴트에 MemberID 값이 없으면 false 방출
        
        // userRepository를 통해 기능 구현해야 함.
        // userRepository.fetchUser(memberID: <#T##Int#>)

        return Empty().eraseToAnyPublisher()
    }
}
