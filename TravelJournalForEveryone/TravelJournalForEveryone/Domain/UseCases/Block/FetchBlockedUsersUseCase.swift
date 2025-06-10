//
//  FetchBlockedUsersUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/31/25.
//

import Foundation
import Combine

protocol FetchBlockedUsersUseCase {
    func execute(pageNumber: Int) -> AnyPublisher<Pageable<UserSummary>, NetworkError>
}

struct DefaultFetchBlockedUsersUseCase: FetchBlockedUsersUseCase {
    private let blockRepository: BlockRepository
    
    init(blockRepository: BlockRepository) {
        self.blockRepository = blockRepository
    }
    
    func execute(pageNumber: Int) -> AnyPublisher<Pageable<UserSummary>, NetworkError> {
        return blockRepository.fetchBlockedUsers(
            pageNumber: pageNumber,
            pageSize: 10
        )
    }
}
