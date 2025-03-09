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
    private let googleAuthService: GoogleAuthService
    
    init(
        kakaoAuthService: KakaoAuthService,
        appleAuthService: AppleAuthService,
        googleAuthService: GoogleAuthService
    ) {
        self.kakaoAuthService = kakaoAuthService
        self.appleAuthService = appleAuthService
        self.googleAuthService = googleAuthService
    }
    
    func loginWith(_ loginType: LoginType) -> AnyPublisher<String?, Error> {
        switch loginType {
        case .kakao: kakaoAuthService.login()
        case .apple: appleAuthService.login()
        case .google: googleAuthService.login()
        }
    }
}
