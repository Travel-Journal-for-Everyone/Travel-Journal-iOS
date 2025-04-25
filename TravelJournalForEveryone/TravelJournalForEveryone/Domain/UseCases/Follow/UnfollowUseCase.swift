//
//  UnfollowUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/24/25.
//

import Foundation
import Combine

protocol UnfollowUseCase {
    func execute(memberID: Int) -> AnyPublisher<Bool, NetworkError>
}

struct DefaultUnfollowUseCase: UnfollowUseCase {
    private let followRepository: FollowRepository
    
    init(followRepository: FollowRepository) {
        self.followRepository = followRepository
    }
    
    func execute(memberID: Int) -> AnyPublisher<Bool, NetworkError> {
        return followRepository.unfollow(memberID: memberID)
    }
}
