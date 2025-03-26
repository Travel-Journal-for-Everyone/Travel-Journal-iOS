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
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    @MainActor
    func execute(loginProvider: SocialType) -> AnyPublisher<Bool, Error> {
        return fetchIDToken(loginProvider: loginProvider)
            .flatMap { idToken in
                return fetchJWTToken(
                    idToken: idToken,
                    loginProvider: loginProvider
                )
            }
            .map { response in
                UserDefaults.standard.set(response.memberID, forKey: UserDefaultsKey.memberID.value)
                UserDefaults.standard.set(response.deviceID, forKey: UserDefaultsKey.deviceID.value)
                UserDefaults.standard.set(loginProvider.rawValue, forKey: UserDefaultsKey.socialType.value)
                
                KeychainManager.save(
                    forAccount: .refreshToken,
                    value: response.refreshToken
                )
                
                return response.isFirstLogin
            }
            .eraseToAnyPublisher()
    }
    
    @MainActor
    private func fetchIDToken(loginProvider: SocialType) -> AnyPublisher<String, Error> {
        return authRepository.fetchIDToken(loginProvider: loginProvider)
    }
    
    private func fetchJWTToken(
        idToken: String,
        loginProvider: SocialType
    ) -> AnyPublisher<FetchJWTTokenResponseDTO, Error> {
        return authRepository.fetchJWTToken(
            idToken: idToken,
            loginProvider: loginProvider
        )
    }
}
