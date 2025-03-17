//
//  AuthStateManager.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/16/25.
//

import Foundation

final class AuthStateManager: ObservableObject {
    @Published private(set) var authState: AuthenticationState = .unauthenticated
    
    func authenticate() {
        authState = .authenticated
    }
    
    func unauthenticate() {
        authState = .unauthenticated
    }
}
