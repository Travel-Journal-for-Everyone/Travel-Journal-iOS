//
//  AccountScope.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/20/25.
//

import Foundation

enum AccountScope: String, CaseIterable {
    case publicProfile
    case followersOnly
    case privateProfile
    
    var key: String {
        switch self {
        case .publicProfile:
            "PUBLIC"
        case .followersOnly:
            "FRIENDS"
        case .privateProfile:
            "PRIVATE"
        }
    }
}
