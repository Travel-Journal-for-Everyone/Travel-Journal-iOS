//
//  DefaultUserRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/28/25.
//

import Foundation
import Combine

final class DefaultUserRepository: UserRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func validateNickname(_ nickname: String) -> AnyPublisher<String, NetworkError> {
        return networkService.request(
            MemberAPI.checkNickname(nickname),
            decodingType: CheckNicknameResponseDTO.self
        )
        .map { response in
            return response.message
        }
        .eraseToAnyPublisher()
    }
    
    func completeFirstLogin(_ request: CompleteFirstLoginRequestDTO) -> AnyPublisher<Bool, Error> {
        return networkService.request(
            MemberAPI.completeFirstLogin(request),
            decodingType: CompleteFirstLoginResponseDTO.self
        )
        .map { response in
            return response.success
        }
        .mapError{ $0 as Error }
        .eraseToAnyPublisher()
    }
}

final class MockUserRepository: UserRepository {
    func validateNickname(_ nickname: String) -> AnyPublisher<String, NetworkError> {
        return ["valid", "valid", "valid", "containsBadWord", "duplicate"]
            .randomElement().publisher
            .setFailureType(to: NetworkError.self)
            .delay(for: .seconds(1.5), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func completeFirstLogin(_ request: CompleteFirstLoginRequestDTO) -> AnyPublisher<Bool, Error> {
        return Just(true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
