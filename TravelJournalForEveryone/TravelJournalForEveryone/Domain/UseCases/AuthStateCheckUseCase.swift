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
            return fetchCurrentUser()
                .map { user in
                    if user.isFirstLogin {
                        #if DEBUG
                        print("⚠️ Not Authenticated: Membership registration has not been completed")
                        #endif
                        
                        return AuthenticationState.unauthenticated
                    } else {
                        DIContainer.shared.userInfoManager.saveUser(user)
                        
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
    
    private func fetchCurrentUser() -> AnyPublisher<User, Error> {
        let memberID = UserDefaults.standard.integer(forKey: UserDefaultsKey.memberID.value)
        
        return userRepository.fetchUser(memberID: memberID)
    }
}
