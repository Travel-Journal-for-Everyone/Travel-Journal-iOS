//
//  AuthenticationViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/23/25.
//

import Foundation
import Combine

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
    
    private let loginUsecase: LoginUseCase
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(loginUsecase: LoginUseCase) {
        self.loginUsecase = loginUsecase
    }
    
    func send(_ intent: AuthenticationIntent) {
        switch intent {
        case .viewOnAppear:
            handleViewOnAppear()
        case .kakaoLogin:
            handleKakaoLogin()
        case .appleLogin:
            handleAppleLogin()
        case .googleLogin:
            handleGoogleLogin()
        case .isPresentedProfileCreationView(let value):
            state.isPresentedProfileCreationView = value
        case .logout:
            handleLogout()
        }
    }
    
    private func handleViewOnAppear() { }
    
    private func handleKakaoLogin() {
        loginUsecase.execute(loginProvider: .kakao)
            .sink { completion in
                switch completion {
                case .finished:
                    print("✅ Kakao Login Success")
                case .failure(let error):
                    print("⛔️ Kakao Login Failure: \(error)")
                }
            } receiveValue: { result in
                if result {
                    self.state.isPresentedProfileCreationView = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleAppleLogin() {
        loginUsecase.execute(loginProvider: .apple)
            .sink { completion in
                switch completion {
                case .finished:
                    print("✅ Apple Login Success")
                case .failure(let error):
                    print("⛔️ Apple Login Failure: \(error)")
                }
            } receiveValue: { result in
                if result {
                    self.state.isPresentedProfileCreationView = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleGoogleLogin() {
        loginUsecase.execute(loginProvider: .google)
            .sink { completion in
                switch completion {
                case .finished:
                    print("✅ Google Login Success")
                case .failure(let error):
                    print("⛔️ Google Login Failure: \(error)")
                }
            } receiveValue: { result in
                if result {
                    self.state.isPresentedProfileCreationView = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleLogout() { }
}
