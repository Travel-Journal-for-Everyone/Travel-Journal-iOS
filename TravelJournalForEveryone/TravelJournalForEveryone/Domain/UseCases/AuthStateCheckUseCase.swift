//
//  AuthStateCheckUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/15/25.
//

import Foundation
import Combine

protocol AuthStateCheckUseCase {
    @MainActor func execute() -> AnyPublisher<AuthenticationState, Never>
}

struct DefaultAuthStateCheckUseCase: AuthStateCheckUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    @MainActor
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
    
    @MainActor
    private func isValidJWTToken() -> AnyPublisher<Bool, Never> {
        let memberID = UserDefaults.standard.integer(forKey: UserDefaultsKey.memberID.value)
        
        guard memberID > 0 else {
            return Just(false).eraseToAnyPublisher()
        }
        
        return userRepository.fetchUser(memberID: memberID)
            .map { user in
                saveUserData(user)
                return true
            }
            .catch { error in
                #if DEBUG
                print("⛔️ Fetch User Failure: \(error)")
                #endif
                
                return Just(false)
            }
            .eraseToAnyPublisher()
    }
    
    @MainActor
    private func saveUserData(_ user: User) {
        DIContainer.shared.userInfoManager.updateUser(
            nickname: user.nickname,
            accountScope: user.accountScope
        )
        
        // TODO: - 나중에 테스트 완료 후 아래 프린트문 지우기!
        print(user)
        print(UserDefaults.standard.integer(forKey: UserDefaultsKey.memberID.value))
    }
}
