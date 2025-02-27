//
//  AuthRepository.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/24/25.
//

import Foundation
import Combine

protocol AuthRepository {
    func loginWith(_ loginType: LoginType) -> AnyPublisher<String?, Error>
}
