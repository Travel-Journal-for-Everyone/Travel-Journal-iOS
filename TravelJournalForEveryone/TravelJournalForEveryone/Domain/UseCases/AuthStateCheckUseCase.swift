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
        let hasAccessToken = KeychainManager.load(forAccount: .accessToken).isSuccess
        let hasRefreshToken = KeychainManager.load(forAccount: .refreshToken).isSuccess
        
        return hasAccessToken && hasRefreshToken
    }
    
    private func isValidJWTToken() -> AnyPublisher<Bool, Never> {
        // TODO: - 백엔드 API 나오면 구현
        // 유저디폴트에 MemberID 값이 없으면 false 방출
        let memberID = UserDefaults.standard.integer(forKey: UserDefaultsKey.memberID.value)
        
        guard memberID > 0 else {
            return Just(false).eraseToAnyPublisher()
        }
        
        // userRepository를 통해 기능 구현해야 함.
        // userRepository.fetchUser(memberID: memberID)

        return Empty().eraseToAnyPublisher()
    }
}
