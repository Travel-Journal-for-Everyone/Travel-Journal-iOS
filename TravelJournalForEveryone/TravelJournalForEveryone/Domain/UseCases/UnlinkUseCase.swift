//
//  UnlinkUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/29/25.
//

import Foundation
import Combine
 
protocol UnlinkUseCase {
    func execute() -> AnyPublisher<Bool, Error>
}

struct DefaultUnlinkUseCase: UnlinkUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute() -> AnyPublisher<Bool, Error> {
        guard let socialType = UserDefaults.standard.string(forKey: UserDefaultsKey.socialType.value) else {
            return Fail(error: UserDefaultsError.dataNotFound)
                .eraseToAnyPublisher()
        }
        
        return authRepository.unlink(socialProvider: SocialType.from(response: socialType))
            .map { isSuccess in
                if isSuccess { deleteInfo() }
        
                return isSuccess
            }
            .mapError{ $0 as Error }
            .eraseToAnyPublisher()
    }
    
    private func deleteInfo() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.deviceID.value)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.memberID.value)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.socialType.value)
        
        KeychainManager.delete(forAccount: .accessToken)
        KeychainManager.delete(forAccount: .refreshToken)
    }
}

