//
//  DefaultAuthRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/24/25.
//

import Foundation
import Combine

final class DefaultAuthRepository: AuthRepository {
    private let socialLoginService: SocialLoginService
    private let socialLogoutService: SocialLogoutService
    private let networkService: NetworkService
    
    init(
        socialLoginService: SocialLoginService,
        socialLogoutService: SocialLogoutService,
        networkService: NetworkService
    ) {
        self.socialLoginService = socialLoginService
        self.socialLogoutService = socialLogoutService
        self.networkService = networkService
    }
    
    @MainActor
    func fetchIDToken(loginProvider: SocialType) -> AnyPublisher<String, Error> {
        socialLoginService.loginWith(loginProvider)
    }
    
    func requestLogin(
        idToken: String,
        loginProvider: SocialType
    ) -> AnyPublisher<LoginInfo, Error> {
        let request = LoginRequest(
            idToken: idToken,
            loginProvider: loginProvider.rawValue
        )
        
        return networkService.request(
            AuthAPI.login(request),
            decodingType: LoginResponseDTO.self
        )
        .map { responseDTO in
            responseDTO.toEntity()
        }
        .mapError { $0 as Error }
        .eraseToAnyPublisher()
    }
    
    func socialLogout(logoutProvider: SocialType) -> AnyPublisher<Bool, Error> {
        return socialLogoutService.logoutWith(logoutProvider)
            .eraseToAnyPublisher()
    }
    
    func requestLogout(devideID: String) -> AnyPublisher<Bool, NetworkError> {
        return networkService.request(
            AuthAPI.logout(deviceID: devideID),
            decodingType: LogoutResponseDTO.self
        )
        .map { response in
            return response.success
        }
        .eraseToAnyPublisher()
    }
}
