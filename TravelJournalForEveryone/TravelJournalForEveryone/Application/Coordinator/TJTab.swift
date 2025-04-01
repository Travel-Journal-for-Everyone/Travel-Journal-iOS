//
//  TJTab.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/25/25.
//

enum TJTab: CaseIterable {
    case myJournal
    case search
    case explore
    case profile
    
    var title: String {
        switch self {
        case .myJournal: "나의 일지"
        case .search: "검색하기"
        case .explore: "탐험하기"
        case .profile: "프로필"
        }
    }
    
    var imageString: String {
        switch self {
        case .myJournal: "TJMyJournal"
        case .search: "TJSearch"
        case .explore: "TJExplore"
        case .profile: "TJProfile"
        }
    }
}
