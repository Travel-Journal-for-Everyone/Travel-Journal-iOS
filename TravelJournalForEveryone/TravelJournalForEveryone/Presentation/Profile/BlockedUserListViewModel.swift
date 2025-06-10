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
    
    private let fetchBlockedUsersUseCase: FetchBlockedUsersUseCase
    private let unblockUseCase: UnblockUseCase
    
    private var currentPageNumber: Int = 0
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        fetchBlockedUsersUseCase: FetchBlockedUsersUseCase,
        unblockUseCase: UnblockUseCase
    ) {
        self.fetchBlockedUsersUseCase = fetchBlockedUsersUseCase
        self.unblockUseCase = unblockUseCase
    }
    
    func send(_ intent: Intent) {
        switch intent {
        case .listViewOnAppear:
            fetchBlockedUsers()
        case .listNextPageOnAppear:
            fetchBlockedUsers()
        case .refreshByButton:
            refreshBlockedUsers(byButton: true)
        case .refreshByPull:
            refreshBlockedUsers(byButton: false)
            
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
        var isInitailLoading: Bool = true
        var isLastPage: Bool = false
        
        var selectedUserNickname: String?
        var selectedUserId: Int?
    }
    
    enum Intent {
        case listViewOnAppear
        case listNextPageOnAppear
        case refreshByButton
        case refreshByPull
        
        case selectedUser(nickname: String, id: Int)
        case unblockedUser
    }
}

extension BlockedUserListViewModel {
    private func fetchBlockedUsers(isRefreshing: Bool = false) {
        var publisher = fetchBlockedUsersUseCase.execute(pageNumber: currentPageNumber)
        
        if isRefreshing {
            publisher = publisher
                .delay(for: .seconds(1), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                
                self.state.isInitailLoading = false
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("⛔️ Fetch Blocked Users Error: \(error)")
                }
            } receiveValue: { [weak self] blockedUsersPage in
                guard let self else { return }
                
                if blockedUsersPage.isEmpty {
                    self.state.blockedUsers.removeAll()
                } else {
                    self.state.blockedUsers.append(contentsOf: blockedUsersPage.contents)
                    self.state.isLastPage = blockedUsersPage.isLast
                    self.currentPageNumber += 1
                }
            }
            .store(in: &cancellables)
    }
    
    private func refreshBlockedUsers(byButton: Bool) {
        self.state.blockedUsers.removeAll()
        self.state.isInitailLoading = true
        self.currentPageNumber = 0
        
        if byButton {
            fetchBlockedUsers(isRefreshing: true)
        } else {
            // 당겨서 새로고침은 딜레이 없이 바로 API 통신
            fetchBlockedUsers()
        }
    }
    
    private func unblockUser(id: Int?) {
        guard let id else { return }
        
        unblockUseCase.execute(memberID: id)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("⛔️ Unblock Error: \(error)")
                }
            } receiveValue: { [weak self] isSuccess in
                guard let self else { return }
                
                withAnimation {
                    self.state.blockedUsers.removeAll { $0.id == id }
                }
            }
            .store(in: &cancellables)
    }
}
