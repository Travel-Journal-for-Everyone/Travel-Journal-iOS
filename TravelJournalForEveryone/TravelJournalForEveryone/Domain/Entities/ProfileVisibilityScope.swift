//
//  ProfileVisibilityScope.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/20/25.
//

import Foundation

enum ProfileVisibilityScope: CaseIterable {
    case publicProfile
    case followersOnly
    case privateProfile
}

extension ProfileVisibilityScope {
    var title: String {
        switch self {
        case .publicProfile: return "전체 공개"
        case .followersOnly: return "팔로우 공개"
        case .privateProfile: return "나만 보기"
        }
    }
    
    var description: String {
        switch self {
        case .publicProfile: 
            return "모든 사용자가 볼 수 있어요."
        case .followersOnly:
            return "나를 팔로워한 사용자만 볼 수 있어요."
        case .privateProfile:
            return "나만 볼 수 있어요."
        }
    }
    
    // MARK: - 추후에 변경될 수 있음
    var iconName: String {
        switch self {
        case .publicProfile:
            return "globe"
        case .followersOnly:
            return "person"
        case .privateProfile:
            return "lock"
        }
    }
}
