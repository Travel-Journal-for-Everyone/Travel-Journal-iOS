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
    
    init(
        userNickname: String,
        folloewrCount: Int,
        followingCount: Int,
        viewType: ActivityOverviewType
    ) {
        self.state.userNickname = userNickname
        self.state.folloewrCount = folloewrCount
        self.state.followingCount = followingCount
        
        switch viewType {
        case .follower:
            self.state.selectedSegmentIndex = 0
        case .following:
            self.state.selectedSegmentIndex = 1
        case .journal, .place:
            break
        }
    }
    
    func send(_ intent: Intent) {
        switch intent {
        case .followerListViewOnAppear:
            handleFollowerListViewOnAppear()
        case .followingListViewOnAppear:
            handleFollowingListViewOnAppear()
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
        var userNickname: String = ""
        var selectedSegmentIndex: Int = 0
        var followingRequestUsers: [UserSummary] = []
        var followingRequestUserCount: Int = 0
        var followers: [UserSummary] = []
        var folloewrCount: Int = 0
        var followings: [UserSummary] = []
        var followingCount: Int = 0
    }
    
    enum Intent {
        case followerListViewOnAppear
        case followingListViewOnAppear
        case selectSegment(Int)
        case tappedFollowingAcceptButton
        case tappedFollowingRejectButton
        case tappedUnfollowButton
    }
}

extension FollowListViewModel {
    private func handleFollowerListViewOnAppear() {
        // TEST
        self.state.followingRequestUsers = [
            .mock(nickname: "지호구"),
            .mock(nickname: "심시미"),
            .mock(nickname: "김짱표"),
        ]
        
        self.state.followers = [
            .mock(nickname: "김마루"),
            .mock(nickname: "마루김마루"),
            .mock(nickname: "쭈리"),
            .mock(nickname: "줄링"),
            .mock(nickname: "줄링줄링이"),
            .mock(nickname: "김몽글"),
            .mock(nickname: "김땡글"),
            .mock(nickname: "김호두"),
        ]
    }
    
    private func handleFollowingListViewOnAppear() {
        // TEST
        self.state.followings = [
            .mock(nickname: "김마루"),
            .mock(nickname: "마루김마루"),
            .mock(nickname: "쭈리"),
            .mock(nickname: "줄링"),
            .mock(nickname: "줄링줄링이"),
            .mock(nickname: "김몽글"),
            .mock(nickname: "김땡글"),
            .mock(nickname: "김호두"),
        ]
    }
}
