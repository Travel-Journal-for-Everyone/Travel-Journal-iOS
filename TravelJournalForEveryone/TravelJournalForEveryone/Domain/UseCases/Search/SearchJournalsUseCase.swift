//
//  SearchJournalsUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 5/7/25.
//

import Foundation
import Combine

protocol SearchJournalsUseCase {
    func execute(
        keyword: String,
        pageNumber: Int
    ) -> AnyPublisher<Pageable<JournalSummary>, NetworkError>
}

struct DefaultSearchJournalsUseCase: SearchJournalsUseCase {
    private let repository: SearchRepository
    
    init(repository: SearchRepository) {
        self.repository = repository
    }
    
    func execute(keyword: String, pageNumber: Int) -> AnyPublisher<Pageable<JournalSummary>, NetworkError> {
        return repository.searchJournals(
            keyword: keyword,
            pageNumber: pageNumber,
            pageSize: 10
        )
    }
}
