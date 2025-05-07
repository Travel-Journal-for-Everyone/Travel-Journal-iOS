//
//  SearchRepository.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/19/25.
//

import Foundation
import Combine

protocol SearchRepository {
    func searchMembers(
        keyword: String,
        pageNumber: Int,
        pageSize: Int
    ) -> AnyPublisher<Pageable<UserSummary>, NetworkError>
    
    func searchPlaces(
        keyword: String,
        pageNumber: Int,
        pageSize: Int
    ) -> AnyPublisher<Pageable<PlaceSummary>, NetworkError>
    
    func searchJournals(
        keyword: String,
        pageNumber: Int,
        pageSize: Int
    ) -> AnyPublisher<Pageable<JournalSummary>, NetworkError>
}
