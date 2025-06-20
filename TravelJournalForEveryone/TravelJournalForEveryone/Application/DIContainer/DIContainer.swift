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
    lazy var placeRepository = DefaultPlaceRepository(networkService: networkService)
    lazy var searchRepository = DefaultSearchRepository(networkService: networkService)
    lazy var followRepository = DefaultFollowRepository(networkService: networkService)
    lazy var exploreRepository = DefaultExploreRepository(networkService: networkService)
    lazy var blockRepository = DefaultBlockRepository(networkService: networkService)
    
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
    lazy var fetchPlacesUseCase = DefaultFetchPlacesUseCase(placeRepository: placeRepository)
    
    //search
    lazy var searchMembersUseCase = DefaultSearchMembersUseCase(repository: searchRepository)
    lazy var searchPlacesUseCase = DefaultSearchPlacesUseCase(repository: searchRepository)
    lazy var searchJournalsUseCase = DefaultSearchJournalsUseCase(repository: searchRepository)
    
    // follow
    lazy var fetchFollowCountUseCase = DefaultFetchFollowCountUseCase(followRepository: followRepository)
    lazy var fetchFollowersUseCase = DefaultFetchFollowersUseCase(followRepository: followRepository)
    lazy var fetchFollowingsUseCase = DefaultFetchFollowingsUseCase(followRepository: followRepository)
    lazy var followUseCase = DefaultFollowUseCase(followRepository: followRepository)
    lazy var unfollowUseCase = DefaultUnfollowUseCase(followRepository: followRepository)
    lazy var checkFollowUseCase = DefaultCheckFollowUseCase(followRepository: followRepository)
    
    // explore
    lazy var fetchExploreJournalsUseCase = DefaultFetchExploreJournalsUseCase(exploreRepository: exploreRepository)
    lazy var markJournalsUseCase = DefaultMarkJournalsUseCase(exploreRepository: exploreRepository)
    
    // block
    lazy var blockUseCase = DefaultBlockUseCase(blockRepository: blockRepository)
    lazy var unblockUseCase = DefaultUnblockUseCase(blockRepository: blockRepository)
    lazy var fetchBlockedUsersUseCase = DefaultFetchBlockedUsersUseCase(blockRepository: blockRepository)
    
    
    // MARK: - Manager
    lazy var authStateManager = AuthStateManager()
    lazy var userInfoManager = UserInfoManager()
    
    
    private init() {}
}
