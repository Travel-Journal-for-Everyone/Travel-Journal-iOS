//
//  AuthStateManager.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/16/25.
//

import Foundation

struct AuthStateManager {
    private(set) var authState: AuthenticationState = .unauthenticated
    
    mutating func authenticate() {
        authState = .authenticated
    }
    
    mutating func unauthenticate() {
        authState = .unauthenticated
    }
}
