//
//  DefaultUserRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/28/25.
//

import Foundation
import Combine

final class DefaultUserRepository: UserRepository {
    // 서버와 통신할 수 있는 Service 객체를 가진다.
    func validateNickname(_ nickname: String) -> AnyPublisher<String, Error> {
        // Service 객체를 String 데이터를 받는다.
        Empty().eraseToAnyPublisher()
    }
}

final class MockUserRepository: UserRepository {
    func validateNickname(_ nickname: String) -> AnyPublisher<String, Error> {
        return Just("valid")
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
