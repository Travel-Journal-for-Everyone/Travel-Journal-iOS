//
//  DIContainer.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/25/25.
//

import Foundation

final class DIContainer {
    @MainActor static let shared = DIContainer()
    
    // MARK: - Services
    lazy var kakaoAuthService = DefaultKakaoAuthService()
    lazy var appleAuthService = DefaultAppleAuthService()
    
    // MARK: - Repositories
    lazy var authRepository = DefaultAuthRepository(
        kakaoAuthService: kakaoAuthService,
        appleAuthService: appleAuthService
    )
    lazy var userRepository = DefaultUserRepository()
    
    // mock
    lazy var mockUserRepository = MockUserRepository()
    
    
    // MARK: - Usecases
    lazy var loginUseCase = DefaultLoginUseCase(authRepository: authRepository)
    lazy var nickNameCheckUseCase = DefaultNicknameCheckUseCase(userRepository: mockUserRepository)
    
    
    private init() {}
}
