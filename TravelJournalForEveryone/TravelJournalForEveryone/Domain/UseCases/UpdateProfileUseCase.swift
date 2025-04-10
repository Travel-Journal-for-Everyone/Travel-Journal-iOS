//
//  LoginCompleteUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/14/25.
//

import Foundation
import Combine

protocol UpdateProfileUseCase {
    @MainActor func execute(
        nickname: String,
        accountScope: AccountScope,
        image: Data?
    ) -> AnyPublisher<Bool, Error>
}

struct DefaultUpdateProfileUseCase: UpdateProfileUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    @MainActor
    func execute(
        nickname: String,
        accountScope: AccountScope,
        image: Data?
    ) -> AnyPublisher<Bool, Error> {
        return userRepository.updateProfile(
            nickname: nickname,
            accountScope: accountScope,
            image: image
        )
        .mapError { $0 as Error }
        .flatMap { isSuccess in
            if isSuccess {
                return fetchCurrentUser()
                    .map { user in
                        DIContainer.shared.userInfoManager.saveUser(user)
                        return true
                    }
                    .catch { error in
                        Fail(error: error)
                    }
                    .eraseToAnyPublisher()
            } else {
                return Just(false)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func fetchCurrentUser() -> AnyPublisher<User, Error> {
        let memberID = UserDefaults.standard.integer(forKey: UserDefaultsKey.memberID.value)
        
        return userRepository.fetchUser(memberID: memberID)
    }
}
