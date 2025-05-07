//
//  DefaultPlaceRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/15/25.
//

import Foundation
import Combine

final class DefaultPlaceRepository: PlaceRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchPlaces(
        memberID: Int,
        regionName: String?,
        pageNumber: Int,
        pageSize: Int
    ) -> AnyPublisher<Pageable<PlaceSummary>, NetworkError> {
        let request = FetchPlacesRequest(
            memberID: memberID,
            regionName: regionName,
            pageNumber: pageNumber,
            pageSize: pageSize
        )
        
        return networkService.request(
            MembersAPI.fetchPlaces(request),
            decodingType: BasePageableDTO<PlaceSummaryDTO>.self
        )
        .map { $0.toEntity() }
        .eraseToAnyPublisher()
    }
}
