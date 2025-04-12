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
    lazy var socialLoginService = DefaultSocialLoginService()
    lazy var socialLogoutService = DefaultSocialLogoutService()
    lazy var networkService = DefaultNetworkService()
    
    
    // MARK: - Repositories
    lazy var authRepository = DefaultAuthRepository(
        socialLoginService: socialLoginService,
        socialLogoutService: socialLogoutService,
        networkService: networkService
    )
    lazy var userRepository = DefaultUserRepository(networkService: networkService)
    lazy var journalRepository = DefaultJournalRepository(networkService: networkService)
    
    // mock
    lazy var mockUserRepository = MockUserRepository()
    
    
    // MARK: - Usecases
    lazy var loginUseCase = DefaultLoginUseCase(
        authRepository: authRepository,
        userRepository: userRepository
    )
    lazy var logoutUseCase = DefaultLogoutUseCase(authRepository: authRepository)
    lazy var nickNameCheckUseCase = DefaultNicknameCheckUseCase(userRepository: userRepository)
    lazy var updateProfileUseCase = DefaultUpdateProfileUseCase(userRepository: userRepository)
    lazy var unlinkUseCase = DefaultUnlinkUseCase(authRepository: authRepository)
    lazy var authStateCheckUseCase = DefaultAuthStateCheckUseCase(userRepository: userRepository)
    lazy var fetchUserUseCase = DefaultFetchUserUseCase(userRepository: userRepository)
    lazy var fetchJournalsUseCase = DefaultFetchJournalsUseCase(journalRepository: journalRepository)
    
    
    // MARK: - Manager
    lazy var authStateManager = AuthStateManager()
    lazy var userInfoManager = UserInfoManager()
    
    
    private init() {}
}
