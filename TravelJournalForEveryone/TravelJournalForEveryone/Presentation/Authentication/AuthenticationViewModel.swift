//
//  AuthenticationViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/23/25.
//

import SwiftUI

// MARK: - State
struct AuthenticationModelState {
    var authenticationState: AuthenticationState = .unauthenticated
    var isPresentedProfileCreationView: Bool = false
}

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

// MARK: - Intent
enum AuthenticationIntent {
    case viewOnAppear
    case kakaoLogin
    case appleLogin
    case googleLogin
    case isPresentedProfileCreationView(Bool)
    case logout
}

// MARK: - ViewModel(State + Intent)
final class AuthenticationViewModel: ObservableObject {
    @Published private(set) var state = AuthenticationModelState()
    
    func send(_ intent: AuthenticationIntent) {
        switch intent {
        case .viewOnAppear:
            // TODO:
            break
        case .kakaoLogin:
            print("kakaoLogin")
            state.isPresentedProfileCreationView = true
        case .appleLogin:
            print("appleLogin")
        case .googleLogin:
            print("googleLogin")
        case .isPresentedProfileCreationView(let value):
            state.isPresentedProfileCreationView = value
        case .logout:
            // TODO:
            break
        }
    }
}
