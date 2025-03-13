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
    private let networkService: NetworkService
    
    init(
        socialLoginAuthService: SocialLoginAuthService,
        networkService: NetworkService
    ) {
        self.socialLoginAuthService = socialLoginAuthService
        self.networkService = networkService
    }
    
    func fetchIDToken(loginProvider: LoginProvider) -> AnyPublisher<String?, Error> {
        socialLoginAuthService.loginWith(loginProvider)
    }
    
    func fetchJWTToken(
        idToken: String,
        loginProvider: LoginProvider
    ) -> AnyPublisher<String?, Error> {
        let request = FetchJWTTokenRequest(
            idToken: idToken,
            loginProvider: loginProvider.rawValue
        )
        
        return networkService.request(
            AuthAPI.fetchJWTToken(request),
            decodingType: FetchJWTTokenResponseDTO.self
        )
        .map { response in
            // TODO: Response의 다른 정보들 나중에 처리하기
            response.refreshToken
        }
        .mapError { $0 as Error }
        .eraseToAnyPublisher()
    }
}
