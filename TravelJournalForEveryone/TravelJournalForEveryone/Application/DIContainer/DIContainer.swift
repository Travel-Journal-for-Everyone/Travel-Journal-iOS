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
    lazy var socialLoginAuthService = DefaultSocialLoginAuthService()
    lazy var networkService = DefaultNetworkService()
    
    
    // MARK: - Repositories
    lazy var authRepository = DefaultAuthRepository(
        socialLoginAuthService: socialLoginAuthService,
        networkService: networkService
    )
    lazy var userRepository = DefaultUserRepository(networkService: networkService)
    
    // mock
    lazy var mockUserRepository = MockUserRepository()
    
    
    // MARK: - Usecases
    lazy var loginUseCase = DefaultLoginUseCase(authRepository: authRepository)
    lazy var nickNameCheckUseCase = DefaultNicknameCheckUseCase(userRepository: userRepository)
    lazy var authStateCheckUseCase = DefaultAuthStateCheckUseCase(userRepository: userRepository)
    
    
    // MARK: - Manager
    lazy var authStateManager = AuthStateManager()
    
    
    private init() {}
}
