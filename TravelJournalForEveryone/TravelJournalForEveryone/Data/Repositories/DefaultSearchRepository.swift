//
//  DefaultSearchRepository.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/19/25.
//

import Foundation
import Combine

final class DefaultSearchRepository: SearchRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func searchMembers(
        keyword: String,
        pageNumber: Int,
        pageSize: Int
    ) -> AnyPublisher<Pageable<UserSummary>, NetworkError> {
        let request = SearchMembersRequest(
            keyword: keyword,
            pageNumber: pageNumber,
            pageSize: pageSize
        )
        
        return networkService.request(
            SearchAPI.searchMembers(request),
            decodingType: SearchMembersResponseDTO.self
        )
        .map { $0.toEntity() }
        .eraseToAnyPublisher()
    }
}
