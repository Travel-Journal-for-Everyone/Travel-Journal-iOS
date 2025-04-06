//
//  UserInfoManager.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/18/25.
//

import Foundation

final class UserInfoManager: ObservableObject {
    @Published private(set) var user: User = .mock()
    
    // MARK: - 추후 개별 프로퍼티가 필요없으면 아래 코드 지우기
    @Published private(set) var nickname: String = ""
    @Published private(set) var profileImageURLString = ""
    @Published private(set) var accounScope: AccountScope = .privateProfile
    
    func saveUser(_ newUser: User) {
        user = newUser
        
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
