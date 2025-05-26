//
//  MarkJournalsUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/18/25.
//

import Foundation
import Combine

protocol MarkJournalsUseCase {
    func execute(journalIDs: [Int]) -> AnyPublisher<Bool, NetworkError>
}

struct DefaultMarkJournalsUseCase: MarkJournalsUseCase {
    private let exploreRepository: ExploreRepository
    
    init(exploreRepository: ExploreRepository) {
        self.exploreRepository = exploreRepository
    }
    
    func execute(journalIDs: [Int]) -> AnyPublisher<Bool, NetworkError> {
        return exploreRepository.markJournalsAsSeen(
            journalIDs: journalIDs
        )
    }
}
