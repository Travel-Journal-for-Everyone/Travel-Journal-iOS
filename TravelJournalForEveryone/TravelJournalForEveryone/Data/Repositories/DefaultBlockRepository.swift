//
//  DefaultBlockRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/31/25.
//

import Foundation
import Combine

final class DefaultBlockRepository: BlockRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func blockUser(memberID: Int) -> AnyPublisher<Bool, NetworkError> {
        return networkService.request(BlockAPI.blockUser(id: memberID))
            .map { stringResponse in
                if stringResponse == "차단 성공" {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    func unblockUser(memberID: Int) -> AnyPublisher<Bool, NetworkError> {
        return networkService.request(BlockAPI.unblockUser(id: memberID))
            .map { stringResponse in
                if stringResponse == "차단 해제 성공" {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchBlockedUsers(
        pageNumber: Int,
        pageSize: Int
    ) -> AnyPublisher<Pageable<UserSummary>, NetworkError> {
        let request = FetchBlockedUsersRequest(
            pageNumber: pageNumber,
            pageSize: pageSize
        )
        
        return networkService.request(
            BlockAPI.fetchBlockedUsers(request),
            decodingType: BasePageableDTO<BlockedUserDTO>.self
        )
        .map { $0.toEntity() }
        .eraseToAnyPublisher()
    }
}
