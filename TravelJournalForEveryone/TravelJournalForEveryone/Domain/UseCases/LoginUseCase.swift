//
//  LoginUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/24/25.
//

import Foundation
import Combine

protocol LoginUseCase {
    func execute(loginProvider: LoginProvider) -> AnyPublisher<Bool, Error>
}

struct DefaultLoginUseCase: LoginUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(loginProvider: LoginProvider) -> AnyPublisher<Bool, Error> {
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
                //TODO: Device ID 처리
                
                KeychainManager.save(
                    forAccount: .refreshToken,
                    value: response.refreshToken
                )
                
                return response.isFirstLogin
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchIDToken(loginProvider: LoginProvider) -> AnyPublisher<String?, Error> {
        return authRepository.fetchIDToken(loginProvider: loginProvider)
    }
    
    private func fetchJWTToken(
        idToken: String,
        loginProvider: LoginProvider
    ) -> AnyPublisher<FetchJWTTokenResponseDTO, Error> {
        return authRepository.fetchJWTToken(
            idToken: idToken,
            loginProvider: loginProvider
        )
    }
}
