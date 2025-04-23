//
//  FollowRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/23/25.
//

import Foundation
import Combine

protocol FollowRepository {
    func fetchFollowCount(memberID: Int) -> AnyPublisher<FollowCountInfo, NetworkError>
    func fetchFollowers(
        memberID: Int,
        pageNumber: Int,
        pageSize: Int
    ) -> AnyPublisher<Pageable<UserSummary>, NetworkError>
}
