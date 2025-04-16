//
//  PlaceRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/15/25.
//

import Foundation
import Combine

protocol PlaceRepository {
    func fetchPlaces(
        memberID: Int,
        regionName: String,
        pageNumber: Int,
        pageSize: Int
    ) -> AnyPublisher<Pageable<PlaceSummary>, NetworkError>
}
