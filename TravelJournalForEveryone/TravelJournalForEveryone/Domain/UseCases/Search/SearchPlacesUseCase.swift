//
//  SearchPlacesUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 5/7/25.
//

import Foundation
import Combine

protocol SearchPlacesUseCase {
    func execute(
        keyword: String,
        pageNumber: Int
    ) -> AnyPublisher<Pageable<PlaceSummary>, NetworkError>
}

struct DefaultSearchPlacesUseCase: SearchPlacesUseCase {
    private let repository: SearchRepository
    
    init(repository: SearchRepository) {
        self.repository = repository
    }
    
    func execute(keyword: String, pageNumber: Int) -> AnyPublisher<Pageable<PlaceSummary>, NetworkError> {
        return repository.searchPlaces(
            keyword: keyword,
            pageNumber: pageNumber,
            pageSize: 10
        )
    }
}
