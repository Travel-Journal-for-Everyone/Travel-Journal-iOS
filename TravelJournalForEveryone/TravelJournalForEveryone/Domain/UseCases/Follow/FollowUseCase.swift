//
//  FollowUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/24/25.
//

import Foundation
import Combine

protocol FollowUseCase {
    func execute(memberID: Int) -> AnyPublisher<Bool, NetworkError>
}

struct DefaultFollowUseCase: FollowUseCase {
    private let followRepository: FollowRepository
    
    init(followRepository: FollowRepository) {
        self.followRepository = followRepository
    }
    
    func execute(memberID: Int) -> AnyPublisher<Bool, NetworkError> {
        return followRepository.follow(memberID: memberID)
    }
}
