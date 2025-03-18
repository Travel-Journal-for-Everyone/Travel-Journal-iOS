//
//  AccountScope.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/20/25.
//

import Foundation

enum AccountScope: String, CaseIterable {
    case publicProfile = "PUBLIC"
    case followersOnly = "FRIENDS"
    case privateProfile = "PRIVATE"

    static func from(response: String) -> Self {
        return AccountScope(rawValue: response) ?? .privateProfile
    }
}
