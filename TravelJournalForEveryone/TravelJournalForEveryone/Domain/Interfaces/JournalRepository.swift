//
//  JournalRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/12/25.
//

import Foundation
import Combine

protocol JournalRepository {
    func fetchJournals(
        memberID: Int,
        regionName: String?,
        pageNumber: Int,
        pageSize: Int
    ) -> AnyPublisher<Pageable<JournalSummary>, NetworkError>
}
