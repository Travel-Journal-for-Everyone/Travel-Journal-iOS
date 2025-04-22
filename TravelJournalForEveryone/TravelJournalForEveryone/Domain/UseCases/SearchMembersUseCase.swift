//
//  SearchMembersUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/19/25.
//

import Foundation
import Combine

protocol SearchMembersUseCase {
    func execute(
        keyword: String,
        pageNumber: Int
    ) -> AnyPublisher<Pageable<UserSummary>, NetworkError>
}

struct DefaultSearchMembersUseCase: SearchMembersUseCase {
    private let repository: SearchRepository
    
    init(repository: SearchRepository) {
        self.repository = repository
    }
    
    func execute(keyword: String, pageNumber: Int) -> AnyPublisher<Pageable<UserSummary>, NetworkError> {
        return repository.searchMembers(
            keyword: keyword,
            pageNumber: pageNumber,
            pageSize: 10
        )
    }
}
