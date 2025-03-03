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
    
    init(kakaoAuthService: KakaoAuthService) {
        self.kakaoAuthService = kakaoAuthService
    }
    
    func loginWith(_ loginType: LoginType) -> AnyPublisher<String?, Error> {
        switch loginType {
        case .kakao:
            return kakaoAuthService.login()
        case .apple:
            return Empty().eraseToAnyPublisher()
        case .google:
            return Empty().eraseToAnyPublisher()
        }
    }
}
