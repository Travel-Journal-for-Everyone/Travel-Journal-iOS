//
//  DIContainer.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/25/25.
//

import Foundation

final class DIContainer {
    @MainActor static let shared = DIContainer()
    
    // Services
    lazy var kakaoAuthService = DefaultKakaoAuthService()
    
    // Repositories
    lazy var authRepository = DefaultAuthRepository(kakaoAuthService: kakaoAuthService)
    
    // Usecases
    lazy var loginUseCase = DefaultLoginUseCase(authRepository: authRepository)
    lazy var nickNameCheckUseCase = DefaultNicknameCheckUseCase()
    
    private init() {}
}
