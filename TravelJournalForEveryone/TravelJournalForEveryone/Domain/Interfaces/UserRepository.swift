//
//  UserRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/28/25.
//

import Foundation
import Combine

protocol UserRepository {
    func validateNickname(_ nickname: String) -> AnyPublisher<String, NetworkError>
    func fetchUser(memberID: Int) -> AnyPublisher<User, Error>
    func updateProfile(
        nickname: String,
        accountScope: AccountScope,
        memberDefaultImage: Bool,
        image: Data?
    ) -> AnyPublisher<Bool, NetworkError>
}
