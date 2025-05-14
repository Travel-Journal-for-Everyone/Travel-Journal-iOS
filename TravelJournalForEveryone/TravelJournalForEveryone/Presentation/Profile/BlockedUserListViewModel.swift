//
//  BlockedUserListViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/13/25.
//

import SwiftUI
import Combine

final class BlockedUserListViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    @MainActor // TEST
    func send(_ intent: Intent) {
        switch intent {
        case .listViewOnAppear:
            fetchBlockedUsers()
        case .listNextPageOnAppear:
            fetchBlockedUsers()
        case .refreshList:
            refreshBlockedUsers()
            
        case .selectedUser(let nickname, let id):
            self.state.selectedUserNickname = nickname
            self.state.selectedUserId = id
        case .unblockedUser:
            unblockUser(id: self.state.selectedUserId)
        }
    }
}

extension BlockedUserListViewModel {
    struct State {
        var blockedUsers: [UserSummary] = []
        var isLoading: Bool = true
        var isLastPage: Bool = false
        
        var selectedUserNickname: String?
        var selectedUserId: Int?
    }
    
    enum Intent {
        case listViewOnAppear
        case listNextPageOnAppear
        case refreshList
        
        case selectedUser(nickname: String, id: Int)
        case unblockedUser
    }
}

extension BlockedUserListViewModel {
    @MainActor // TEST
    private func fetchBlockedUsers() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.state.isLoading = false
            self.state.isLastPage = true
            
            self.state.blockedUsers = [
                .mock(id: 0, nickname: "김마루1"),
                .mock(id: 1, nickname: "김마루2"),
                .mock(id: 2, nickname: "김마루3"),
                .mock(id: 3, nickname: "김마루4"),
                .mock(id: 4, nickname: "김마루5"),
                .mock(id: 5, nickname: "김마루6"),
                .mock(id: 6, nickname: "김마루7"),
                .mock(id: 7, nickname: "김마루8"),
                .mock(id: 8, nickname: "김마루9"),
                .mock(id: 9, nickname: "김마루10"),
                .mock(id: 10, nickname: "김마루11"),
                .mock(id: 11, nickname: "김마루12"),
                .mock(id: 12, nickname: "김마루13"),
                .mock(id: 13, nickname: "김마루14"),
                .mock(id: 14, nickname: "김마루15")
            ]
        }
    }
    
    private func refreshBlockedUsers() {
        print("차단 목록 리프레쉬")
    }
    
    private func unblockUser(id: Int?) {
        print("유저ID \(id ?? 0) 차단 해제")
        
        withAnimation {
            self.state.blockedUsers.removeAll { $0.id == id ?? 0 }
        }
    }
}
