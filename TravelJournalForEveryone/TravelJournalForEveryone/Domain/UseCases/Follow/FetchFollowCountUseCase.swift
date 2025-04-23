//
//  FetchFollowCountUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/23/25.
//

import Foundation
import Combine

protocol FetchFollowCountUseCase {
    func execute(memberID: Int) -> AnyPublisher<FollowCountInfo, NetworkError>
}

struct DefaultFetchFollowCountUseCase: FetchFollowCountUseCase {
    private let followRepository: FollowRepository
    
    init(followRepository: FollowRepository) {
        self.followRepository = followRepository
    }
    
    func execute(memberID: Int) -> AnyPublisher<FollowCountInfo, NetworkError> {
        return followRepository.fetchFollowCount(memberID: memberID)
    }
}
