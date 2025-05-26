//
//  FetchExploreJournalsUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/18/25.
//

import Foundation
import Combine

protocol FetchExploreJournalsUseCase {
    func execute(pageNumber: Int) -> AnyPublisher<Pageable<ExploreJournalSummary>, NetworkError>
}

struct DefaultFetchExploreJournalsUseCase: FetchExploreJournalsUseCase {
    private let exploreRepository: ExploreRepository
    
    init(exploreRepository: ExploreRepository) {
        self.exploreRepository = exploreRepository
    }
    
    func execute(pageNumber: Int) -> AnyPublisher<Pageable<ExploreJournalSummary>, NetworkError> {
        return exploreRepository.fetchExploreJournals(
            pageNumber: pageNumber,
            pageSize: 10
        )
    }
}
