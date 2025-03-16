//
//  UserRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/28/25.
//

import Foundation
import Combine

protocol UserRepository {
    func validateNickname(_ nickname: String) -> AnyPublisher<String, Error>
    func fetchUser(memberID: Int) -> AnyPublisher<User, NetworkError>
}
