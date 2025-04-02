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
    
    var imageString: (selected: String, unselected: String) {
        switch self {
        case .myJournal:
            ("TJMyJournal.selected", "TJMyJournal")
        case .search:
            ("TJSearch.selected", "TJSearch")
        case .explore:
            ("TJExplore.selected", "TJExplore")
        case .profile:
            ("TJProfile.selected", "TJProfile")
        }
    }
}
