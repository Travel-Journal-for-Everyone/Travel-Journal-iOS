//
//  MyJournalViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/5/25.
//

import Foundation
import Combine

// MARK: - State
struct MyJournalState {
    var user: User = .mock()
    var isInitialView: Bool = true
    var isCurrentUser: Bool = true
    var isFollowing: Bool = false
    var isTouchDisabled: Bool = false
    
    var selectedActivityOverviewType: ActivityOverviewType = .journal
    var selectedRegion: Region = .metropolitan
}

// MARK: - Intent
enum MyJournalIntent {
    case viewOnAppear
    case sheetDismissed
    case tappedFollowButton
    case tappedBlockButton
    case tappedReportButton
    case tappedActivityOverviewButton(ActivityOverviewType)
    case tappedRegionButton(Region)
}

// MARK: - ViewModel(State + Intent)
final class MyJournalViewModel: ObservableObject {
    @Published private(set) var state = MyJournalState()
    
    private let memberID: Int?
    private let fetchUserUseCase: FetchUserUseCase
    
    private var cancellables: Set<AnyCancellable> = []
    
    /// - Parameters:
    ///     - memberID: 입력하지 않을 경우(=nil), 현재 사용자의 정보를 보는 ViewModel로 활용합니다.
    ///     입력할 경우, 다른 사용자의 정보를 보는 ViewModel로 활용합니다.
    init(
        memberID: Int? = nil,
        fetchUserUseCase: FetchUserUseCase
    ) {
        self.memberID = memberID
        self.fetchUserUseCase = fetchUserUseCase
        
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
    func send(_ intent: MyJournalIntent) {
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
    
    @MainActor
    private func handleViewOnAppear() {
        if self.state.isCurrentUser {
            self.state.user = DIContainer.shared.userInfoManager.user
        } else {
            fetchUserUseCase.execute(memberID: self.memberID ?? 0)
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
        self.state.isFollowing.toggle()
    }
    
    private func handleTappedBlockButton() {
        
    }
    
    private func handleTappedReportButton() {
        
    }
}
