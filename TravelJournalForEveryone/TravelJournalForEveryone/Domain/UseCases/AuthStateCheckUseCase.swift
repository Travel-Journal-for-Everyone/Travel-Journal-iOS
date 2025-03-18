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
    
    private func saveUserData(_ user: User) {
        // TODO: - 유저 객체에 데이터 저장하기
        print(user)
        print(UserDefaults.standard.integer(forKey: UserDefaultsKey.memberID.value))
    }
}
