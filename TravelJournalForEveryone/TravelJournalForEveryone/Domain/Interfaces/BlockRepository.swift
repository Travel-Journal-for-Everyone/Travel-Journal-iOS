//
//  BlockRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/28/25.
//

import Foundation
import Combine

protocol BlockRepository {
    func blockUser(memberID: Int) -> AnyPublisher<Bool, NetworkError>
    func unblockUser(memberID: Int) -> AnyPublisher<Bool, NetworkError>
    func fetchBlockedUsers(
        pageNumber: Int,
        pageSize: Int
    ) -> AnyPublisher<Pageable<UserSummary>, NetworkError>
}
