//
//  LoginCompleteUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/14/25.
//

import Foundation
import Combine

protocol SignUpUseCase {
    @MainActor func execute(
        nickname: String,
        accountScope: AccountScope
    ) -> AnyPublisher<Bool, Error>
}

struct DefaultLoginCompleteUseCase: SignUpUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    @MainActor
    func execute(
        nickname: String,
        accountScope: AccountScope
    ) -> AnyPublisher<Bool, Error> {
        return userRepository.completeSignUp(
            nickname: nickname,
            accountScope: accountScope
        )
        .mapError { $0 as Error }
        .flatMap { isSuccess in
            if isSuccess {
                return fetchUser()
                    .map { user in
                        saveUser(user)
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
    
    private func fetchUser() -> AnyPublisher<User, Error> {
        let memberID = UserDefaults.standard.integer(forKey: UserDefaultsKey.memberID.value)
        
        return userRepository.fetchUser(memberID: memberID)
    }
    
    @MainActor
    private func saveUser(_ user: User) {
        DIContainer.shared.userInfoManager.updateUser(
            nickname: user.nickname,
            accountScope: user.accountScope
        )
    }
}
