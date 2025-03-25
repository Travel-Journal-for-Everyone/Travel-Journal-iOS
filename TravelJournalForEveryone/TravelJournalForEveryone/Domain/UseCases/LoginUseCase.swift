//
//  LoginUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/24/25.
//

import Foundation
import Combine

protocol LoginUseCase {
    func execute(loginProvider: SocialType) -> AnyPublisher<Bool, Error>
}

struct DefaultLoginUseCase: LoginUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(loginProvider: SocialType) -> AnyPublisher<Bool, Error> {
        return fetchIDToken(loginProvider: loginProvider)
            .flatMap { idToken -> AnyPublisher<FetchJWTTokenResponseDTO, Error> in
                guard let idToken else {
                    return Just(
                        .init(
                            memberID: 0,
                            isFirstLogin: false,
                            refreshToken: "",
                            deviceID: ""
                        )
                    )
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
                }
                
                return self.fetchJWTToken(
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
    
    private func fetchIDToken(loginProvider: SocialType) -> AnyPublisher<String?, Error> {
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
