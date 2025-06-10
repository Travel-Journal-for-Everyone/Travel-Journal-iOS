//
//  UnblockUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/31/25.
//

import Foundation
import Combine

protocol UnblockUseCase {
    func execute(memberID: Int) -> AnyPublisher<Bool, NetworkError>
}

struct DefaultUnblockUseCase: UnblockUseCase {
    private let blockRepository: BlockRepository
    
    init(blockRepository: BlockRepository) {
        self.blockRepository = blockRepository
    }
    
    func execute(memberID: Int) -> AnyPublisher<Bool, NetworkError> {
        return blockRepository.unblockUser(memberID: memberID)
    }
}
