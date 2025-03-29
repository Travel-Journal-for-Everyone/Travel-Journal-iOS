//
//  UserInfoManager.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/18/25.
//

import Foundation

final class UserInfoManager: ObservableObject {
    @Published private(set) var nickname: String = ""
    @Published private(set) var profileImageURLString = ""
    @Published private(set) var accounScope: AccountScope = .privateProfile
    
    func saveUser(_ newUser: User) {
        updateNickname(newUser.nickname)
        updateProfileImageURLString(newUser.profileImageURLString)
        updateAccountScope(newUser.accountScope)
    }
    
    func updateNickname(_ newNickname: String) {
        nickname = newNickname
    }
    
    func updateProfileImageURLString(_ newProfileImageURLString: String) {
        profileImageURLString = newProfileImageURLString
    }
    
    func updateAccountScope(_ newAccountScope: AccountScope) {
        accounScope = newAccountScope
    }
}
