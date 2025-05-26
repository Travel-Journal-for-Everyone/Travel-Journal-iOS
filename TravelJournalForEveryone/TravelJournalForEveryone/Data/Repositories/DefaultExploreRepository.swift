//
//  DefaultExploreRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/18/25.
//

import Foundation
import Combine

final class DefaultExploreRepository: ExploreRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchExploreJournals(
        pageNumber: Int,
        pageSize: Int
    ) -> AnyPublisher<Pageable<ExploreJournalSummary>, NetworkError> {
        let request = FetchExploreJournalsRequest(
            pageNumber: pageNumber,
            pageSize: pageSize
        )
        
        return networkService.request(
            ExploreAPI.fetchExploreJournals(request),
            decodingType: BasePageableDTO<ExploreJournalSummaryDTO>.self
        )
        .map { $0.toEntity() }
        .eraseToAnyPublisher()
    }
    
    func markJournalsAsSeen(journalIDs: [Int]) -> AnyPublisher<Bool, NetworkError> {
        return networkService.request(
            ExploreAPI.markJournalsAsSeen(
                journalIDs: journalIDs
            )
        )
        .map { stringResponse in
            if stringResponse == "요청 성공" {
                return true
            } else {
                return false
            }
        }
        .eraseToAnyPublisher()
    }
}
