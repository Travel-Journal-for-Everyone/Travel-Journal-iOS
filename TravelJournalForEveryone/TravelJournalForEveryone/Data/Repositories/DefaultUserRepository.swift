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
    
    func completeSignUp(_ request: SignUpRequestDTO) -> AnyPublisher<Bool, NetworkError> {
        return networkService.request(
            MemberAPI.signUp(request),
            decodingType: SignUpResponseDTO.self
        )
        .map { response in
            return response.success
        }
        .eraseToAnyPublisher()
    }
    
    func fetchUser(memberID: Int) -> AnyPublisher<User, Error> {
        // TODO: - 백엔드 API 나오면 구현
        guard memberID > 0 else {
            return Fail(error: UserDefaultsError.dataNotFound)
                .eraseToAnyPublisher()
        }
        
        return networkService.request(
            MemberAPI.fetchUser(memberID: memberID),
            decodingType: FetchUserDTO.self
        )
        .map { fetchUserDTO in
            return fetchUserDTO.toEntity()
        }
        .mapError { networkError in
            return networkError
        }
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
    
    func completeSignUp(_ request: SignUpRequestDTO) -> AnyPublisher<Bool, NetworkError> {
        return Just(true)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchUser(memberID: Int) -> AnyPublisher<User, Error> {
        // TODO: - 백엔드 API 나오면 구현
        return Just(
            User(
                nickname: "마루김마루",
                accountScope: .publicProfile,
                isFirstLogin: false
            )
        )
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
}
