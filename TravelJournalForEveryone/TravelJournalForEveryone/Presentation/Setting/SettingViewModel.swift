//
//  SettingViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 5/26/25.
//

import Foundation
import Combine

final class SettingViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    func send(_ intent: Intent) {
        switch intent {
        case .viewOnAppear:
            handleViewOnAppear()
        case .allToggleTapped:
            allToggle()
        case .commentToggleTapped:
            commentToggle()
        case .likeToggleTapped:
            likeToggle()
        case .followToggleTapped:
            followToggle()
        }
    }
}

extension SettingViewModel {
    struct State {
        var isAllPushOn: Bool = true
        var isCommentPushOn: Bool = false
        var isLikePushOn: Bool = false
        var isFollowPushOn: Bool = false
        
    }
    
    enum Intent {
        case viewOnAppear
        
        case allToggleTapped
        case commentToggleTapped
        case likeToggleTapped
        case followToggleTapped
        
//        case all
    }
}

extension SettingViewModel {
    private func handleViewOnAppear() {
        // 푸시 세팅값 불러오기
    }
    
    private func allToggle() {
        state.isAllPushOn.toggle()
    }
    
    private func commentToggle() {
        state.isCommentPushOn.toggle()
    }
    
    private func likeToggle() {
        state.isLikePushOn.toggle()
    }
    
    private func followToggle() {
        state.isFollowPushOn.toggle()
    }
}
