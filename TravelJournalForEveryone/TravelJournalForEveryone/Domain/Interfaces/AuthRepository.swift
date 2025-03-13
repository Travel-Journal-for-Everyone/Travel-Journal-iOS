//
//  AuthRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/24/25.
//

import Foundation
import Combine

protocol AuthRepository {
    func fetchIDToken(loginProvider: LoginProvider) -> AnyPublisher<String?, Error>
    func fetchJWTToken(
        idToken: String,
        loginProvider: LoginProvider
    ) -> AnyPublisher<String?, Error>
}
