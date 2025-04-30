//
//  CheckFollowUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/24/25.
//

import Foundation
import Combine

protocol CheckFollowUseCase {
    func execute(memberID: Int) -> AnyPublisher<Bool, NetworkError>
}

struct DefaultCheckFollowUseCase: CheckFollowUseCase {
    private let followRepository: FollowRepository
    
    init(followRepository: FollowRepository) {
        self.followRepository = followRepository
    }
    
    func execute(memberID: Int) -> AnyPublisher<Bool, NetworkError> {
        return followRepository.isFollowing(memberID: memberID)
    }
}
