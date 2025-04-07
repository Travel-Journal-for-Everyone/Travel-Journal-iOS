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
            MemberAPI.checkNickname(nickname)
        )
        .eraseToAnyPublisher()
    }
    
    func updateProfile(
        nickname: String,
        accountScope: AccountScope,
        image: Data?
    ) -> AnyPublisher<Bool, NetworkError> {
        let request = ProfileInfoRequestDTO(
            nickname: nickname,
            accountScope: accountScope,
            imageData: image
        )
        
        return networkService.request(
            MemberAPI.updateProfile(request)
        )
        .map { stringResponse in
            if stringResponse == "요청이 성공적으로 처리되었습니다." {
                return true
            } else {
                return false
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchUser(memberID: Int) -> AnyPublisher<User, Error> {
        guard memberID > 0 else {
            return Fail(error: UserDefaultsError.dataNotFound)
                .eraseToAnyPublisher()
        }
        
        return networkService.request(
            MembersAPI.fetchUser(memberID: memberID),
            decodingType: FetchUserResponseDTO.self
        )
        .map { responseDTO in
            return responseDTO.toEntity()
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
    
    func updateProfile(
        nickname: String,
        accountScope: AccountScope,
        image: Data?
    ) -> AnyPublisher<Bool, NetworkError> {
        return Just(true)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchUser(memberID: Int) -> AnyPublisher<User, Error> {
        return Just(
            User.mock()
        )
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
}
