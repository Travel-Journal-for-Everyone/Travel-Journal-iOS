//
//  LoginUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/24/25.
//

import Foundation
import Combine

protocol LoginUseCase {
    @MainActor func execute(loginProvider: SocialType) -> AnyPublisher<Bool, Error>
}

struct DefaultLoginUseCase: LoginUseCase {
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    
    init(
        authRepository: AuthRepository,
        userRepository: UserRepository
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    @MainActor
    func execute(loginProvider: SocialType) -> AnyPublisher<Bool, Error> {
        return fetchIDToken(loginProvider: loginProvider)
            .flatMap { idToken in
                requestLogin(
                    idToken: idToken,
                    loginProvider: loginProvider
                )
                .mapError { $0 as Error }
            }
            .flatMap { loginInfo in
                saveLoginInfo(loginInfo, loginProvider: loginProvider)
                
                if loginInfo.isFirstLogin {
                    return Just(true)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    return fetchCurrentUser()
                        .handleEvents(receiveOutput: { user in
                            DIContainer.shared.userInfoManager.saveUser(user)
                        })
                        .map { _ in false }
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    @MainActor
    private func fetchIDToken(loginProvider: SocialType) -> AnyPublisher<String, Error> {
        return authRepository.fetchIDToken(loginProvider: loginProvider)
    }
    
    private func requestLogin(
        idToken: String,
        loginProvider: SocialType
    ) -> AnyPublisher<LoginInfo, NetworkError> {
        return authRepository.requestLogin(
            idToken: idToken,
            loginProvider: loginProvider
        )
    }
    
    private func saveLoginInfo(_ loginInfo: LoginInfo, loginProvider: SocialType) {
        UserDefaults.standard.set(loginInfo.memberID, forKey: UserDefaultsKey.memberID.value)
        UserDefaults.standard.set(loginInfo.deviceID, forKey: UserDefaultsKey.deviceID.value)
        UserDefaults.standard.set(loginProvider.rawValue, forKey: UserDefaultsKey.socialType.value)
        
        KeychainManager.save(
            forAccount: .refreshToken,
            value: loginInfo.refreshToken
        )
    }
    
    private func fetchCurrentUser() -> AnyPublisher<User, Error> {
        let memberID = UserDefaults.standard.integer(forKey: UserDefaultsKey.memberID.value)
        
        return userRepository.fetchUser(memberID: memberID)
    }
}
