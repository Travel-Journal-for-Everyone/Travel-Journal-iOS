//
//  UserInfoManager.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/18/25.
//

import Foundation

final class UserInfoManager: ObservableObject {
    @Published private(set) var nickname: String = ""
    @Published private(set) var accounScope: AccountScope = .privateProfile
    
    func updateNickname(_ newNickname: String) {
        nickname = newNickname
    }
    
    func updateAccountScope(_ newAccountScope: AccountScope) {
        accounScope = newAccountScope
    }
    
    func updateUser(
        nickname: String,
        accountScope: AccountScope
    ) {
        updateNickname(nickname)
        updateAccountScope(accountScope)
    }
}
