//
//  Screen.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/25/25.
//

import Foundation

enum Screen: Hashable {
    // MyJournal Tab
    case myJournal(memberID: Int?)
    case followList(
        memberID: Int?,
        isCurrentUser: Bool,
        nickname: String,
        viewType: ActivityOverviewType
    )
    
    // Search Tab
    // Explore Tab
    // Profile Tab
    case profileFix
    case blockedUserList
    case setting
    case pushSetting
    case screenSetting
}
