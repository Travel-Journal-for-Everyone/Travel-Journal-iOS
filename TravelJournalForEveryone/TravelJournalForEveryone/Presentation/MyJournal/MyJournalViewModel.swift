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
        
    }
    
    private func handleTappedFollowButton() {
        self.state.isFollowing.toggle()
    }
    
    private func handleTappedBlockButton() {
        
    }
    
    private func handleTappedReportButton() {
        
    }
}
