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
        let request = SearchRequest(
            keyword: keyword,
            pageNumber: pageNumber,
            pageSize: pageSize
        )
        
        return networkService.request(
            SearchAPI.search(type: .member, request: request),
            decodingType: BasePageableDTO<SearchMembersDTO>.self
        )
        .map { $0.toEntity() }
        .eraseToAnyPublisher()
    }
}
