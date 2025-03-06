//
//  DefaultAuthRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/24/25.
//

import Foundation
import Combine

final class DefaultAuthRepository: AuthRepository {
    
    private let kakaoAuthService: KakaoAuthService
    private let appleAuthService: AppleAuthService
    
    init(
        kakaoAuthService: KakaoAuthService,
        appleAuthService: AppleAuthService
    ) {
        self.kakaoAuthService = kakaoAuthService
        self.appleAuthService = appleAuthService
    }
    
    func loginWith(_ loginType: LoginType) -> AnyPublisher<String?, Error> {
        switch loginType {
        case .kakao:
            return kakaoAuthService.login()
        case .apple:
            return appleAuthService.login()
        case .google:
            return Empty().eraseToAnyPublisher()
        }
    }
}
