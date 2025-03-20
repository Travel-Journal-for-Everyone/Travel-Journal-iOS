//
//  LogoutUseCase.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/20/25.
//

import Foundation
import Combine

protocol LogoutUseCase {
    func execute() -> AnyPublisher<Bool, NetworkError>
}

struct DefaultLogoutUseCase: LogoutUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    // 소셜 로그아웃 추가하기
    func execute() -> AnyPublisher<Bool, NetworkError> {
        guard let deviceID = UserDefaults.standard.string(forKey: UserDefaultsKey.deviceID.value) else {
            return Just(false)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        return authRepository.logout(devideID: deviceID)
            .map { response in
                if response.success {
                    deleteInfo()
                }
                
                return response.success
            }
            .eraseToAnyPublisher()
    }
    
    private func deleteInfo() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.deviceID.value)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.memberID.value)
        
        KeychainManager.delete(forAccount: .accessToken)
        KeychainManager.delete(forAccount: .refreshToken)
    }
}
