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
}

// MARK: - Intent
enum MyJournalIntent {
    case viewOnAppear
    case tappedFollowButton
    case tappedBlockButton
    case tappedReportButton
}

// MARK: - ViewModel(State + Intent)
final class MyJournalViewModel: ObservableObject {
    @Published private(set) var state = MyJournalState()
    private let memberID: Int?
    
    /// - Parameters:
    ///     - memberID: 입력하지 않을 경우(=nil), 현재 사용자의 정보를 보는 ViewModel로 활용합니다.
    ///     입력할 경우, 다른 사용자의 정보를 보는 ViewModel로 활용합니다.
    init(memberID: Int? = nil) {
        self.memberID = memberID
        
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
    
    func send(_ intent: MyJournalIntent) {
        switch intent {
        case .viewOnAppear:
            handleViewOnAppear()
        case .tappedFollowButton:
            handleTappedFollowButton()
        case .tappedBlockButton:
            handleTappedBlockButton()
        case .tappedReportButton:
            handleTappedReportButton()
        }
    }
    
    private func handleViewOnAppear() {
        if self.state.isCurrentUser {
            // TODO: - user 객체에서 user 할당하기
            // self.state.user = DIContainer.shared.userInfoManager.user
        } else {
            // TODO: - MemeberID와 UseCase를 통해 User 정보 Fetch 하기
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
