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
    func fetchAuthCredential(loginProvider: SocialType) -> AnyPublisher<String, Error> {
        socialLoginService.loginWith(loginProvider)
    }
    
    func requestLogin(
        authCredential: String,
        loginProvider: SocialType
    ) -> AnyPublisher<LoginInfo, NetworkError> {
        let request = LoginRequest(
            authCredential: authCredential,
            loginProvider: loginProvider.rawValue
        )
        
        switch loginProvider {
        case .kakao:
            return networkService.request(
                AuthAPI.loginByIDToken(request),
                decodingType: LoginResponseDTO.self
            )
            .map { responseDTO in
                responseDTO.toEntity()
            }
            .eraseToAnyPublisher()
        case .apple, .google:
            return networkService.request(
                AuthAPI.loginByAuthCode(request),
                decodingType: LoginResponseDTO.self
            )
            .map { responseDTO in
                responseDTO.toEntity()
            }
            .eraseToAnyPublisher()
        }
    }
    
    func socialLogout(logoutProvider: SocialType) -> AnyPublisher<Bool, Error> {
        return socialLogoutService.logoutWith(logoutProvider)
            .eraseToAnyPublisher()
    }
    
    func requestLogout(devideID: String) -> AnyPublisher<Bool, NetworkError> {
        return networkService.request(
            AuthAPI.logout(deviceID: devideID)
        )
        .map { stringResponse in
            if stringResponse == "로그아웃 성공" {
                return true
            } else {
                return false
            }
        }
        .eraseToAnyPublisher()
    }
    
    func unlink(socialProvider: SocialType) -> AnyPublisher<Bool, NetworkError> {
        return networkService.request(
            AuthAPI.unlink(socialProvider: socialProvider.rawValue)
        )
        .map { stringResponse in
            if stringResponse == "연결끊기 성공" {
                return true
            } else {
                return false
            }
        }
        .eraseToAnyPublisher()
    }
}
