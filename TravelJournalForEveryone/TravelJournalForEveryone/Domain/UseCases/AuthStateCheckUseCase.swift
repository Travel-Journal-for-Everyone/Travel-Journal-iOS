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
            return fetchUser()
                .map { user in
                    if user.isFirstLogin {
                        #if DEBUG
                        print("⚠️ Not Authenticated: Membership registration has not been completed")
                        #endif
                        
                        return AuthenticationState.unauthenticated
                    } else {
                        saveUserData(user)
                        
                        #if DEBUG
                        print("✅ Authenticated")
                        #endif
                        
                        return AuthenticationState.authenticated
                    }
                }
                .catch { error in
                    #if DEBUG
                    print("⛔️ AuthState check error: \(error)")
                    #endif
                    
                    return Just(AuthenticationState.unauthenticated)
                }
                .eraseToAnyPublisher()
        } else {
            #if DEBUG
            print("⚠️ Not Authenticated: JWTToken not found in Keychain")
            #endif
            
            return Just(AuthenticationState.unauthenticated)
                .eraseToAnyPublisher()
        }
    }
    
    private func hasJWTTokenInKeychain() -> Bool {
        let hasAccessToken = KeychainManager.load(forAccount: .accessToken).isSuccess
        let hasRefreshToken = KeychainManager.load(forAccount: .refreshToken).isSuccess
        
        return hasAccessToken && hasRefreshToken
    }
    
    private func fetchUser() -> AnyPublisher<User, Error> {
        let memberID = UserDefaults.standard.integer(forKey: UserDefaultsKey.memberID.value)
        
        guard memberID > 0 else {
            return Fail(error: UserDefaultsError.dataNotFound)
                .eraseToAnyPublisher()
        }
        
        return userRepository.fetchUser(memberID: memberID)
            .map { user in
                return user
            }
            .mapError { networkError in
                return networkError
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
