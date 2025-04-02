//
//  TJTab.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/25/25.
//

import SwiftUI

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
    
    var symbolImage: (selected: ImageResource, unselected: ImageResource) {
        switch self {
        case .myJournal:
            (.tjMyJournalSelected, .tjMyJournal)
        case .search:
            (.tjSearchSelected, .tjSearch)
        case .explore:
            (.tjExploreSelected, .tjExplore)
        case .profile:
            (.tjProfileSelected, .tjProfile)
        }
    }
}
