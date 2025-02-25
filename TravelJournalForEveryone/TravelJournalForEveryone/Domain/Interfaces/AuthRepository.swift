//
//  AuthRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/24/25.
//

import Foundation
import Combine

protocol AuthRepository {
    func loginWithKakao() -> AnyPublisher<String, LoginError>
    // func loginWithApple() -> AnyPublisher<String, LoginError>
    // func loginWithGoogle() -> AnyPublisher<String, LoginError>
}
