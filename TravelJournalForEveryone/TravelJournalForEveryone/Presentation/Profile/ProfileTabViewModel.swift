//
//  ProfileTabViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/9/25.
//

import SwiftUI

@MainActor
final class ProfileTabViewModel: ObservableObject {
    @Published private(set) var state = State()
    private let userInfoManager: UserInfoManager = DIContainer.shared.userInfoManager
    
    func send(_ intent: Intent) {
        switch intent {
        case .viewOnAppear:
            handleViewOnAppear()
        }
    }
}

extension ProfileTabViewModel {
    struct State {
        var user: User = .mock()
    }
    
    enum Intent {
        case viewOnAppear
    }
}

extension ProfileTabViewModel {
    private func handleViewOnAppear() {
        let user = DIContainer.shared.userInfoManager.user
        state.user = user
    }
}

