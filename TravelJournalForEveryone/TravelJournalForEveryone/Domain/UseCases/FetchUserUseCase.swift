//
//  FetchUserUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/5/25.
//

import Foundation
import Combine

protocol FetchUserUseCase {
    func execute(memberID: Int) -> AnyPublisher<User, Error>
}

struct DefaultFetchUserUseCase: FetchUserUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(memberID: Int) -> AnyPublisher<User, Error> {
        return userRepository.fetchUser(memberID: memberID)
            .eraseToAnyPublisher()
    }
}
