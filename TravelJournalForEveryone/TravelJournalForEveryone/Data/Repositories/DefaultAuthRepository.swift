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
    
    init(socialLoginAuthService: SocialLoginAuthService) {
        self.socialLoginAuthService = socialLoginAuthService
    }
    
    func loginWith(_ loginProvider: LoginProvider) -> AnyPublisher<String?, Error> {
        socialLoginAuthService.loginWith(loginProvider)
    }
}
