//
//  DefaultUserRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/28/25.
//

import Foundation
import Combine

final class DefaultUserRepository: UserRepository {
    // 서버와 통신할 수 있는 Network Service 객체를 가진다.
    
    func validateNickname(_ nickname: String) -> AnyPublisher<String, Error> {
        // Network Service 객체를 통해 String 데이터를 받는다.
        Empty().eraseToAnyPublisher()
    }
}

final class MockUserRepository: UserRepository {
    func validateNickname(_ nickname: String) -> AnyPublisher<String, Error> {
        return ["valid", "valid", "valid", "containsBadWord", "duplicate"]
            .randomElement().publisher
            .setFailureType(to: Error.self)
            .delay(for: .seconds(1.5), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
