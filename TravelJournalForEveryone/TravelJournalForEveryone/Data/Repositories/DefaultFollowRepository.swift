//
//  DefaultFollowRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/23/25.
//

import Foundation
import Combine

final class DefaultFollowRepository: FollowRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchFollowCount(memberID: Int) -> AnyPublisher<FollowCountInfo, NetworkError> {
        return networkService.request(
            FollowAPI.fetchFollowCount(memberID: memberID),
            decodingType: FetchFollowCountResponseDTO.self
        )
        .map { $0.toEntity() }
        .eraseToAnyPublisher()
    }
    
    func fetchFollowers(
        memberID: Int,
        pageNumber: Int,
        pageSize: Int
    ) -> AnyPublisher<Pageable<UserSummary>, NetworkError> {
        let request = FetchFollowRequest(
            memberID: memberID,
            pageNumber: pageNumber,
            pageSize: pageSize
        )
        
        return networkService.request(
            FollowAPI.fetchFollowers(request),
            decodingType: FetchFollowResponseDTO.self
        )
        .map { $0.toEntity() }
        .eraseToAnyPublisher()
    }
    
    func fetchFollowings(
        memberID: Int,
        pageNumber: Int,
        pageSize: Int
    ) -> AnyPublisher<Pageable<UserSummary>, NetworkError> {
        let request = FetchFollowRequest(
            memberID: memberID,
            pageNumber: pageNumber,
            pageSize: pageSize
        )
        
        return networkService.request(
            FollowAPI.fetchFollowings(request),
            decodingType: FetchFollowResponseDTO.self
        )
        .map { $0.toEntity() }
        .eraseToAnyPublisher()
    }
}
