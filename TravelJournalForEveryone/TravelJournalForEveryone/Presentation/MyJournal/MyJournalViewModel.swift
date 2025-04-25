//
//  MyJournalViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/5/25.
//

import Foundation
import Combine

final class MyJournalViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    private let fetchUserUseCase: FetchUserUseCase
    private let followUseCase: FollowUseCase
    private let unfollowUseCase: UnfollowUseCase
    private let checkFollowUseCase: CheckFollowUseCase
    
    private var cancellables: Set<AnyCancellable> = []
    
    /// - Parameters:
    ///     - memberID: 입력하지 않을 경우(=nil), 현재 사용자의 정보를 보는 ViewModel로 활용합니다.
    ///     입력할 경우, 다른 사용자의 정보를 보는 ViewModel로 활용합니다.
    init(
        memberID: Int? = nil,
        fetchUserUseCase: FetchUserUseCase,
        followUseCase: FollowUseCase,
        unfollowUseCase: UnfollowUseCase,
        checkFollowUseCase: CheckFollowUseCase
    ) {
        self.fetchUserUseCase = fetchUserUseCase
        self.followUseCase = followUseCase
        self.unfollowUseCase = unfollowUseCase
        self.checkFollowUseCase = checkFollowUseCase
        self.state.memberID = memberID
        
        guard let memberID else {
            self.state.isInitialView = true
            self.state.isCurrentUser = true
            return
        }
        
        self.state.isInitialView = false
        
        if memberID == UserDefaults.standard.integer(forKey: UserDefaultsKey.memberID.value) {
            self.state.isCurrentUser = true
        } else {
            self.state.isCurrentUser = false
        }
    }
    
    @MainActor
    func send(_ intent: Intent) {
        switch intent {
        case .viewOnAppear:
            handleViewOnAppear()
        case .sheetDismissed:
            handleSheetDismissed()
        case .tappedFollowButton:
            handleTappedFollowButton()
        case .tappedBlockButton:
            handleTappedBlockButton()
        case .tappedReportButton:
            handleTappedReportButton()
        case .tappedActivityOverviewButton(let type):
            self.state.selectedActivityOverviewType = type
        case .tappedRegionButton(let region):
            self.state.selectedRegion = region
        }
    }
}

extension MyJournalViewModel {
    struct State {
        var user: User = .mock()
        var memberID: Int?
        var isInitialView: Bool = true
        var isCurrentUser: Bool = true
        var isFollowing: Bool = false
        var isTouchDisabled: Bool = false
        
        var isLoadingFollowState: Bool = true
        
        var selectedActivityOverviewType: ActivityOverviewType = .journal
        var selectedRegion: Region = .metropolitan
    }
    
    enum Intent {
        case viewOnAppear
        case sheetDismissed
        case tappedFollowButton
        case tappedBlockButton
        case tappedReportButton
        case tappedActivityOverviewButton(ActivityOverviewType)
        case tappedRegionButton(Region)
    }
}

extension MyJournalViewModel {
    @MainActor
    private func handleViewOnAppear() {
        if self.state.isCurrentUser {
            self.state.user = DIContainer.shared.userInfoManager.user
        } else {
            self.state.isLoadingFollowState = true
            
            fetchUserUseCase.execute(memberID: self.state.memberID ?? 0)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("⛔️ Fetch User Error: \(error)")
                    }
                } receiveValue: { [weak self] fetchedUser in
                    self?.state.user = fetchedUser
                }
                .store(in: &cancellables)
            
            checkFollowUseCase.execute(memberID: self.state.memberID ?? 0)
                .sink { [weak self] completion in
                    guard let self else { return }
                    
                    switch completion {
                    case .finished:
                        self.state.isLoadingFollowState = false
                    case .failure(let error):
                        print("⛔️ Check Follow State Error: \(error)")
                    }
                } receiveValue: { [weak self] isFollowing in
                    guard let self else { return }
                    self.state.isFollowing = isFollowing
                }
                .store(in: &cancellables)
        }
    }
    
    @MainActor
    private func handleSheetDismissed() {
        self.state.isTouchDisabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.state.isTouchDisabled = false
        }
    }
    
    private func handleTappedFollowButton() {
        if self.state.isFollowing {
            unfollowUseCase.execute(memberID: self.state.memberID ?? 0)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("⛔️ Unfollow Error: \(error)")
                    }
                } receiveValue: { [weak self] isSuccess in
                    guard let self else { return }
                    self.state.isFollowing = false
                }
                .store(in: &cancellables)
        } else {
            followUseCase.execute(memberID: self.state.memberID ?? 0)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("⛔️ follow Error: \(error)")
                    }
                } receiveValue: { [weak self] isSuccess in
                    guard let self else { return }
                    self.state.isFollowing = true
                }
                .store(in: &cancellables)
        }
    }
    
    private func handleTappedBlockButton() {
        
    }
    
    private func handleTappedReportButton() {
        
    }
}
