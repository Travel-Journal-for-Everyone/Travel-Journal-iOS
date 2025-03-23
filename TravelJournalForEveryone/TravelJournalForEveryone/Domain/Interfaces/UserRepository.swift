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
    func completeSignUp(
        nickname: String,
        accountScope: AccountScope
    ) -> AnyPublisher<Bool, NetworkError>
    func fetchUser(memberID: Int) -> AnyPublisher<User, Error>
}
