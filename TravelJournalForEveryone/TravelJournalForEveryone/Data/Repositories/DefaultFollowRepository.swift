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
}
