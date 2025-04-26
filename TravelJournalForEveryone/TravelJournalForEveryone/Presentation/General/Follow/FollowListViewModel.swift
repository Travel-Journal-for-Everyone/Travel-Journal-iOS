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
    private let fetchFollowingsUseCase: FetchFollowingsUseCase
    private let unfollowUseCase: UnfollowUseCase
    
    private let memberID: Int?
    private var currentFollowersPageNumber: Int = 0
    private var currentFollowingsPageNumber: Int = 0
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        fetchFollowCountUseCase: FetchFollowCountUseCase,
        fetchFollowersUseCase: FetchFollowersUseCase,
        fetchFollowingsUseCase: FetchFollowingsUseCase,
        unfollowUseCase: UnfollowUseCase,
        memberID: Int?,
        isCurrentUser: Bool,
        nickname: String,
        viewType: ActivityOverviewType
    ) {
        self.fetchFollowCountUseCase = fetchFollowCountUseCase
        self.fetchFollowersUseCase = fetchFollowersUseCase
        self.fetchFollowingsUseCase = fetchFollowingsUseCase
        self.unfollowUseCase = unfollowUseCase
        self.memberID = memberID
        self.state.isCurrentUser = isCurrentUser
        self.state.nickname = nickname
        
        updateSegmentIndex(viewType: viewType)
    }
    
    func send(_ intent: Intent) {
        switch intent {
        case .listViewOnAppear:
            fetchFollowCount(memberID: memberID)
        case .followerListViewOnAppear:
            fetchFollowers(memberID: memberID)
        case .followerListNextPageOnAppear:
            fetchFollowers(memberID: memberID)
        case .followingListViewOnAppear:
            fetchFollowings(memberID: memberID)
        case .followingListNextPageOnAppear:
            fetchFollowings(memberID: memberID)
        case .selectSegment(let index):
            self.state.selectedSegmentIndex = index
        case .tappedFollowingAcceptButton:
            break
        case .tappedFollowingRejectButton:
            break
        case .tappedUnfollowButton(let memberID):
            unfollow(memberID: memberID)
        }
    }
}

extension FollowListViewModel {
    struct State {
        var nickname: String = ""
        var isCurrentUser: Bool = false
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
        case tappedUnfollowButton(memberID: Int)
    }
}

extension FollowListViewModel {
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
    
    private func fetchFollowings(memberID: Int?) {
        fetchFollowingsUseCase.execute(
            memberID: memberID,
            pageNumber: currentFollowingsPageNumber
        )
        .sink { [weak self] completion in
            guard let self else { return }
            
            switch completion {
            case .finished:
                self.state.isFollowingsInitialLoading = false
            case .failure(let error):
                print("⛔️ Fetch Followings Error: \(error)")
            }
        } receiveValue: { [weak self] followingsPage in
            guard let self else { return }
            
            if followingsPage.isEmpty {
                self.state.followings = []
            } else {
                self.state.followings.append(
                    contentsOf: followingsPage.contents
                )
                self.state.isLastFollowingsPage = followingsPage.isLast
                self.currentFollowingsPageNumber += 1
            }
        }
        .store(in: &cancellables)
    }
    
    private func unfollow(memberID: Int) {
        unfollowUseCase.execute(memberID: memberID)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("⛔️ Unfollow Error: \(error)")
                }
            } receiveValue: { [weak self] isSuccess in
                guard let self else { return }
                
                if isSuccess {
                    self.fetchFollowCount(memberID: self.memberID)
                    self.state.followings.removeAll { $0.id == memberID }
                }
            }
            .store(in: &cancellables)
    }
}
