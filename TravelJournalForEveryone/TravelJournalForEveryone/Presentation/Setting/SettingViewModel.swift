//
//  SettingViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 5/26/25.
//

import Foundation
import Combine

enum ScreenType: CaseIterable {
    case light
    case dark
    case system
    
    var title: String {
        switch self {
        case .light:
            "라이트 모드"
        case .dark:
            "다크 모드"
        case .system:
            "기기 설정과 동일"
        }
    }
}

enum PushType: CaseIterable {
    case comment
    case like
    case follow
    
    var title: String {
        switch self {
        case .comment:
            "댓글 알림"
        case .like:
            "좋아요 알림"
        case .follow:
            "팔로우 요청 알림"
        }
    }
}

final class SettingViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    func send(_ intent: Intent) {
        switch intent {
        case .viewOnAppear:
            handleViewOnAppear()
        case .allToggleTapped:
            allToggle()
        case .pushTypeTapped(let type):
            pushTypeToggle(type: type)
        case .changeScreenType(let type):
            changeScreenType(type)
        }
    }
}

extension SettingViewModel {
    struct State {
        var isAllPushOn: Bool = true
        var pushList: [PushType] = []
        
        var screenType: ScreenType = .light
    }
    
    enum Intent {
        case viewOnAppear
        
        case allToggleTapped
        case pushTypeTapped(type: PushType)
        
        case changeScreenType(type: ScreenType)
    }
}

extension SettingViewModel {
    private func handleViewOnAppear() {
        // 푸시 세팅값 불러오기
        for type in PushType.allCases {
            state.pushList.append(type)
        }
    }
    
    private func allToggle() {
        state.isAllPushOn.toggle()
        
        if state.isAllPushOn {
            for type in PushType.allCases {
                state.pushList.append(type)
            }
        } else {
            state.pushList = []
        }
    }
    
    private func pushTypeToggle(type: PushType) {
        if state.pushList.contains(type) {
            guard let index = state.pushList.firstIndex(of: type) else { return }
            state.pushList.remove(at: index)
        } else {
            state.pushList.append(type)
        }
    }
    
    private func changeScreenType(_ type: ScreenType) {
        state.screenType = type
    }
}
