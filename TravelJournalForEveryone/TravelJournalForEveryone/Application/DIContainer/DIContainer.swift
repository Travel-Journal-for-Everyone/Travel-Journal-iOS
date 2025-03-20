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
    lazy var logoutUseCase = DefaultLogoutUseCase(authRepository: authRepository)
    lazy var nickNameCheckUseCase = DefaultNicknameCheckUseCase(userRepository: userRepository)
    lazy var signUpUseCase = DefaultLoginCompleteUseCase(userRepository: userRepository)
    // TODO: - Mock 레포지토리 주입 상태!!!
    lazy var authStateCheckUseCase = DefaultAuthStateCheckUseCase(userRepository: mockUserRepository)
    
    
    // MARK: - Manager
    lazy var authStateManager = AuthStateManager()
    lazy var userInfoManager = UserInfoManager()
    
    
    private init() {}
}
