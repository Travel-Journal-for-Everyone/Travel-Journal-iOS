//
//  ProfileVisibilityScope+ViewProperty.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/23/25.
//

import Foundation

extension ProfileVisibilityScope {
    var title: String {
        switch self {
        case .publicProfile: "전체 공개"
        case .followersOnly: "팔로우 공개"
        case .privateProfile: "나만 보기"
        }
    }
    
    var description: String {
        switch self {
        case .publicProfile: "모든 사용자가 볼 수 있어요."
        case .followersOnly: "나를 팔로우한 사용자만 볼 수 있어요."
        case .privateProfile: "나만 볼 수 있어요."
        }
    }
    
    // MARK: - 추후에 변경될 수 있음
    var imageResourceString: String {
        switch self {
        case .publicProfile: "TJGlobe"
        case .followersOnly: "TJPerson"
        case .privateProfile: "TJLock"
        }
    }
}
