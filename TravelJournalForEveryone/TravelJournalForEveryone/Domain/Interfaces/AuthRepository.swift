//
//  AuthRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/24/25.
//

import Foundation
import Combine

protocol AuthRepository {
    @MainActor func fetchAuthCredential(loginProvider: SocialType) -> AnyPublisher<String, Error>
    func requestLogin(
        authCredential: String,
        loginProvider: SocialType
    ) -> AnyPublisher<LoginInfo, NetworkError>
    func socialLogout(logoutProvider: SocialType) -> AnyPublisher<Bool, Error>
    func requestLogout(devideID: String) -> AnyPublisher<Bool, NetworkError>
    func unlink(socialProvider: SocialType) -> AnyPublisher<Bool, NetworkError>
}
