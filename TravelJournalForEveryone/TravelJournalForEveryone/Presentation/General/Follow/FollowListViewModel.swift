//
//  FollowListViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/9/25.
//

import Foundation
import Combine

final class FollowListViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    private let fetchFollowCountUseCase: FetchFollowCountUseCase
    private let fetchFollowersUseCase: FetchFollowersUseCase
    
    private let memberID: Int?
    private var currentFollowersPageNumber: Int = 0
    private var currentFollowingPageNumber: Int = 0
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        fetchFollowCountUseCase: FetchFollowCountUseCase,
        fetchFollowersUseCase: FetchFollowersUseCase,
        memberID: Int?,
        nickname: String,
        viewType: ActivityOverviewType
    ) {
        self.fetchFollowCountUseCase = fetchFollowCountUseCase
        self.fetchFollowersUseCase = fetchFollowersUseCase
        self.memberID = memberID
        self.state.nickname = nickname
        
        updateSegmentIndex(viewType: viewType)
    }
    
    func send(_ intent: Intent) {
        switch intent {
        case .listViewOnAppear:
            handleFollowerListViewOnAppear()
        case .followerListViewOnAppear:
            fetchFollowers(memberID: memberID)
        case .followerListNextPageOnAppear:
            fetchFollowers(memberID: memberID)
        case .followingListViewOnAppear:
            handleFollowingListViewOnAppear()
        case .followingListNextPageOnAppear:
            break
        case .selectSegment(let index):
            self.state.selectedSegmentIndex = index
        case .tappedFollowingAcceptButton:
            break
        case .tappedFollowingRejectButton:
            break
        case .tappedUnfollowButton:
            break
        }
    }
}

extension FollowListViewModel {
    struct State {
        var nickname: String = ""
        var selectedSegmentIndex: Int = 0
        
        var followingRequestUsers: [UserSummary] = []
        var followingRequestUserCount: Int = 0
        
        var followers: [UserSummary] = []
        var followerCount: Int = 0
        var isFollowersInitialLoading: Bool = true
        var isLastFollowersPage: Bool = false
        
        var followings: [UserSummary] = []
        var followingCount: Int = 0
        var isFollowingsInitialLoading: Bool = true
        var isLastFollowingsPage: Bool = false
    }
    
    enum Intent {
        case listViewOnAppear
        case followerListViewOnAppear
        case followerListNextPageOnAppear
        case followingListViewOnAppear
        case followingListNextPageOnAppear
        
        case selectSegment(Int)
        case tappedFollowingAcceptButton
        case tappedFollowingRejectButton
        case tappedUnfollowButton
    }
}

extension FollowListViewModel {
    private func handleFollowerListViewOnAppear() {
        fetchFollowCount(memberID: memberID)
        
        // TEST
        self.state.followingRequestUsers = [
//            .mock(id: 0, nickname: "지호구"),
//            .mock(id: 1, nickname: "심시미"),
//            .mock(id: 2, nickname: "김짱표"),
        ]
    }
    
    private func handleFollowingListViewOnAppear() {
        // TEST
        self.state.followings = [
            .mock(id: 3, nickname: "김마루"),
            .mock(id: 4, nickname: "마루김마루"),
            .mock(id: 5, nickname: "쭈리"),
            .mock(id: 6, nickname: "줄링"),
            .mock(id: 7, nickname: "줄링줄링이"),
            .mock(id: 8, nickname: "김몽글"),
            .mock(id: 9, nickname: "김땡글"),
            .mock(id: 10, nickname: "김호두"),
        ]
    }
    
    private func updateSegmentIndex(viewType: ActivityOverviewType) {
        switch viewType {
        case .follower:
            self.state.selectedSegmentIndex = 0
        case .following:
            self.state.selectedSegmentIndex = 1
        case .journal, .place:
            break
        }
    }
    
    private func fetchFollowCount(memberID: Int?) {
        fetchFollowCountUseCase.execute(memberID: memberID)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("⛔️ Fetch Follow Count Error: \(error)")
                }
            } receiveValue: { [weak self] followCountInfo in
                guard let self else { return }
                
                self.state.followerCount = followCountInfo.followers
                self.state.followingCount = followCountInfo.followings
            }
            .store(in: &cancellables)
    }
    
    private func fetchFollowers(memberID: Int?) {
        fetchFollowersUseCase.execute(
            memberID: memberID,
            pageNumber: currentFollowersPageNumber
        )
        .sink { [weak self] completion in
            guard let self else { return }
            
            switch completion {
            case .finished:
                self.state.isFollowersInitialLoading = false
            case .failure(let error):
                print("⛔️ Fetch Followers Error: \(error)")
            }
        } receiveValue: { [weak self] followersPage in
            guard let self else { return }
            
            if followersPage.isEmpty {
                self.state.followers = []
            } else {
                self.state.followers.append(
                    contentsOf: followersPage.contents
                )
                self.state.isLastFollowersPage = followersPage.isLast
                self.currentFollowersPageNumber += 1
            }
        }
        .store(in: &cancellables)
    }
}
