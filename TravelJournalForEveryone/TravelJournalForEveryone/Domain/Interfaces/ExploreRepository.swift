//
//  ExploreRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/17/25.
//

import Foundation
import Combine

protocol ExploreRepository {
    func fetchExploreJournals(
        pageNumber: Int,
        pageSize: Int
    ) -> AnyPublisher<Pageable<ExploreJournalSummary>, NetworkError>
    func markJournalsAsSeen(journalIDs: [Int]) -> AnyPublisher<Bool, NetworkError>
}
