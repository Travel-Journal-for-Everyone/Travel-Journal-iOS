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

// MARK: - Intent
enum AuthenticationIntent {
    case viewOnAppear
    case kakaoLogin
    case appleLogin
    case googleLogin
    case isPresentedProfileCreationView(Bool)
    case startButtonTapped
    case logout
}

// MARK: - ViewModel(State + Intent)
@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published private(set) var state = AuthenticationModelState()
    
    @Published private var authState = DIContainer.shared.authStateManager.authState
    
    private let loginUsecase: LoginUseCase
    private let authStateCheckUseCase: AuthStateCheckUseCase
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        loginUsecase: LoginUseCase,
        authStateCheckUseCase: AuthStateCheckUseCase
    ) {
        self.loginUsecase = loginUsecase
        self.authStateCheckUseCase = authStateCheckUseCase
        
        bind()
    }
    
    private func bind() {
        $authState
            .sink { [unowned self] authState in
                self.state.authenticationState = authState
            }
            .store(in: &cancellables)
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
        case .startButtonTapped:
            state.authenticationState = .authenticated
        case .logout:
            handleLogout()
        }
    }
    
    private func handleViewOnAppear() {
        authStateCheckUseCase.execute()
            .sink { authState in
                switch authState {
                case .unauthenticated:
                    DIContainer.shared.authStateManager.unauthenticate()
                case .authenticated:
                    DIContainer.shared.authStateManager.authenticate()
                }
            }
            .store(in: &cancellables)
    }
    
    private func navigateViewByResult(_ result: Bool) {
        if result {
            state.isPresentedProfileCreationView = true
        } else {
            state.authenticationState = .authenticated
        }
    }
    
    private func handleKakaoLogin() {
        loginUsecase.execute(loginProvider: .kakao)
            .sink { completion in
                switch completion {
                case .finished:
                    print("✅ Kakao Login Success")
                case .failure(let error):
                    print("⛔️ Kakao Login Failure: \(error)")
                }
            } receiveValue: { [unowned self] result in
                navigateViewByResult(result)
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
            } receiveValue: { [unowned self] result in
                navigateViewByResult(result)
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
            } receiveValue: { [unowned self] result in
                navigateViewByResult(result)
            }
            .store(in: &cancellables)
    }
    
    private func handleLogout() { }
}
