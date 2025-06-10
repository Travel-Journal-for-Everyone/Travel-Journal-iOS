//
//  Coordinator.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/25/25.
//

import SwiftUI

protocol CoordinatorProtocol: ObservableObject {
    var myJournalPath: NavigationPath { get set }
    var searchPath: NavigationPath { get set }
    var explorePath: NavigationPath { get set }
    var profilePath: NavigationPath { get set }
    
    var selectedTab: TJTab { get set }
    
    func push(_ screen: Screen)
    func pop()
    func popToRoot()
}

final class DefaultCoordinator: CoordinatorProtocol {
    @Published var myJournalPath =  NavigationPath() {
        didSet {
            updateTabBarVisibility(self.myJournalPath)
        }
    }
    @Published var searchPath =  NavigationPath() {
        didSet {
            updateTabBarVisibility(self.searchPath)
        }
    }
    @Published var explorePath =  NavigationPath() {
        didSet {
            updateTabBarVisibility(self.explorePath)
        }
    }
    @Published var profilePath =  NavigationPath() {
        didSet {
            updateTabBarVisibility(self.profilePath)
        }
    }
    @Published var selectedTab: TJTab = .myJournal
    @Published var isPresentingTabBar: Bool = true
    
    func push(_ screen: Screen) {
        switch selectedTab {
        case .myJournal:
            myJournalPath.append(screen)
        case .search:
            searchPath.append(screen)
        case .explore:
            explorePath.append(screen)
        case .profile:
            profilePath.append(screen)
        }
    }
    
    func pop() {
        switch selectedTab {
        case .myJournal:
            myJournalPath.removeLast()
        case .search:
            searchPath.removeLast()
        case .explore:
            explorePath.removeLast()
        case .profile:
            profilePath.removeLast()
        }
    }
    
    func popToRoot() {
        switch selectedTab {
        case .myJournal:
            myJournalPath.removeLast(myJournalPath.count)
        case .search:
            searchPath.removeLast(searchPath.count)
        case .explore:
            explorePath.removeLast(explorePath.count)
        case .profile:
            profilePath.removeLast(profilePath.count)
        }
    }
    
    @MainActor
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .myJournal(let memberID):
            MyJournalView(
                viewModel: .init(
                    memberID: memberID,
                    fetchUserUseCase: DIContainer.shared.fetchUserUseCase,
                    followUseCase: DIContainer.shared.followUseCase,
                    unfollowUseCase: DIContainer.shared.unfollowUseCase,
                    checkFollowUseCase: DIContainer.shared.checkFollowUseCase,
                    blockUseCase: DIContainer.shared.blockUseCase,
                    unblockUseCase: DIContainer.shared.unblockUseCase
                )
            )
        case .followList(let memberID, let isCurrentUser, let nickname, let viewType):
            FollowListView(
                viewModel: .init(
                    fetchFollowCountUseCase: DIContainer.shared.fetchFollowCountUseCase,
                    fetchFollowersUseCase: DIContainer.shared.fetchFollowersUseCase,
                    fetchFollowingsUseCase: DIContainer.shared.fetchFollowingsUseCase,
                    unfollowUseCase: DIContainer.shared.unfollowUseCase,
                    memberID: memberID,
                    isCurrentUser: isCurrentUser,
                    nickname: nickname,
                    viewType: viewType
                )
            )
        case .profileFix:
            ProfileCreationView(
                viewModel: ProfileCreationViewModel(
                    nicknameCheckUseCase: DIContainer.shared.nickNameCheckUseCase,
                    updateProfileUseCase: DIContainer.shared.updateProfileUseCase,
                    isEditing: true
                )
            )
        case .blockedUserList:
            BlockedUserListView(
                viewModel: .init(
                    fetchBlockedUsersUseCase: DIContainer.shared.fetchBlockedUsersUseCase,
                    unblockUseCase: DIContainer.shared.unblockUseCase
                )
            )
        case .setting:
            SettingView()
        case .pushSetting:
            PushSettingView(viewModel: .init())
        case .screenSetting:
            ScreenSettingView(viewModel: .init())
        }
    }
    
    private func updateTabBarVisibility(_ path: NavigationPath) {
        withAnimation {
            isPresentingTabBar = path.count == 0
        }
    }
}
