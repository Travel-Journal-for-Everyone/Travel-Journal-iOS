//
//  DefaultAuthRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/24/25.
//

import Foundation
import Combine

final class DefaultAuthRepository: AuthRepository {
    private let socialLoginAuthService: SocialLoginAuthService
    private let socialLogoutService: SocialLogoutService
    private let networkService: NetworkService
    
    init(
        socialLoginAuthService: SocialLoginAuthService,
        socialLogoutService: SocialLogoutService,
        networkService: NetworkService
    ) {
        self.socialLoginAuthService = socialLoginAuthService
        self.socialLogoutService = socialLogoutService
        self.networkService = networkService
    }
    
    func fetchIDToken(loginProvider: SocialType) -> AnyPublisher<String?, Error> {
        socialLoginAuthService.loginWith(loginProvider)
    }
    
    func fetchJWTToken(
        idToken: String,
        loginProvider: SocialType
    ) -> AnyPublisher<FetchJWTTokenResponseDTO, Error> {
        let request = FetchJWTTokenRequest(
            idToken: idToken,
            loginProvider: loginProvider.rawValue
        )
        
        return networkService.request(
            AuthAPI.fetchJWTToken(request),
            decodingType: FetchJWTTokenResponseDTO.self
        )
        .mapError { $0 as Error }
        .eraseToAnyPublisher()
    }
    
    func socialLogout(logoutProvider: SocialType) -> AnyPublisher<Bool, Error> {
        return socialLogoutService.logoutWith(logoutProvider)
            .eraseToAnyPublisher()
    }
    
    func requestLogout(devideID: String) -> AnyPublisher<LogoutResponseDTO, NetworkError> {
        return networkService.request(
            AuthAPI.logout(devideID),
            decodingType: LogoutResponseDTO.self
        )
        .eraseToAnyPublisher()
    }
}
