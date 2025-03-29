//
//  LogoutUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/20/25.
//

import Foundation
import Combine

protocol LogoutUseCase {
    func execute() -> AnyPublisher<Bool, Error>
}

struct DefaultLogoutUseCase: LogoutUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute() -> AnyPublisher<Bool, Error> {
        guard let deviceID = UserDefaults.standard.string(forKey: UserDefaultsKey.deviceID.value),
              let socialType = UserDefaults.standard.string(forKey: UserDefaultsKey.socialType.value) else {
            return Fail(error: UserDefaultsError.dataNotFound)
                .eraseToAnyPublisher()
        }

        return authRepository.requestLogout(devideID: deviceID)
            .map { isSuccess in
                if isSuccess {
                    deleteInfo()
                    _ = authRepository.socialLogout(logoutProvider: SocialType.from(response: socialType))
                }
        
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
