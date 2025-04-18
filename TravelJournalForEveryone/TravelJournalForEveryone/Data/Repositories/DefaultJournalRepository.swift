//
//  DefaultJournalRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/12/25.
//

import Foundation
import Combine

final class DefaultJournalRepository: JournalRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchJournals(
        memberID: Int,
        regionName: String?,
        pageNumber: Int,
        pageSize: Int
    ) -> AnyPublisher<Pageable<JournalSummary>, NetworkError> {
        let request = FetchJournalsRequest(
            memberID: memberID,
            regionName: regionName,
            pageNumber: pageNumber,
            pageSize: pageSize
        )
        
        return networkService.request(
            MembersAPI.fetchJournals(request),
            decodingType: FetchJournalsResponseDTO.self
        )
        .map { $0.toEntity() }
        .eraseToAnyPublisher()
    }
}
