//
//  AuthenticationViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/23/25.
//

import Foundation
import Combine

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    private let loginUseCase: LoginUseCase
    private let logoutUseCase: LogoutUseCase
    private let authStateCheckUseCase: AuthStateCheckUseCase
    private let unlinkUseCase: UnlinkUseCase
    
    private let authStateManager = DIContainer.shared.authStateManager
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        loginUseCase: LoginUseCase,
        logoutUseCase: LogoutUseCase,
        authStateCheckUseCase: AuthStateCheckUseCase,
        unlinkUseCase: UnlinkUseCase
    ) {
        self.loginUseCase = loginUseCase
        self.logoutUseCase = logoutUseCase
        self.authStateCheckUseCase = authStateCheckUseCase
        self.unlinkUseCase = unlinkUseCase
        
        bind()
    }
    
    func send(_ intent: Intent) {
        switch intent {
        case .authenticationViewOnAppear:
            handleAuthenticationViewOnAppear()
        case .signUpCompletionViewOnAppear:
            handleSignUpCompletionViewOnAppear()
        case .kakaoLogin:
            handleKakaoLogin()
        case .appleLogin:
            handleAppleLogin()
        case .googleLogin:
            handleGoogleLogin()
        case .isPresentedProfileCreationView(let value):
            state.isPresentedProfileCreationView = value
        case .startButtonTapped:
            DIContainer.shared.authStateManager.authenticate()
            state.isPresentedProfileCreationView = false
        case .logout:
            handleLogout()
        case .unlink:
            handleUnlink()
        }
    }
}

extension AuthenticationViewModel {
    struct State {
        var authenticationState: AuthenticationState = .unauthenticated
        var isPresentedProfileCreationView: Bool = false
        var isLoading: Bool = false
        var nickname: String = ""
    }
    
    enum Intent {
        case authenticationViewOnAppear
        case signUpCompletionViewOnAppear
        case kakaoLogin
        case appleLogin
        case googleLogin
        case isPresentedProfileCreationView(Bool)
        case startButtonTapped
        case logout
        case unlink
    }
}

extension AuthenticationViewModel {
    private func bind() {
        authStateManager.$authState
            .sink { [unowned self] authState in
                self.state.authenticationState = authState
            }
            .store(in: &cancellables)
    }
    
    private func handleAuthenticationViewOnAppear() {
        authStateCheckUseCase.execute()
            .sink { authState in
                switch authState {
                case .unauthenticated:
                    DIContainer.shared.authStateManager.unauthenticate()
                case .authenticated:
                    DIContainer.shared.authStateManager.authenticate()
                case .authenticating:
                    DIContainer.shared.authStateManager.authenticating()
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleSignUpCompletionViewOnAppear() {
        self.state.nickname = DIContainer.shared.userInfoManager.nickname
    }
    
    private func navigateViewByResult(_ result: Bool) {
        if result {
            state.isPresentedProfileCreationView = true
        } else {
            DIContainer.shared.authStateManager.authenticate()
        }
    }
    
    private func handleKakaoLogin() {
        state.isLoading = true
        
        loginUseCase.execute(loginProvider: .kakao)
            .sink { [unowned self] completion in
                self.state.isLoading = false
                
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
        state.isLoading = true
        
        loginUseCase.execute(loginProvider: .apple)
            .sink { [unowned self] completion in
                self.state.isLoading = false
                
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
        state.isLoading = true
        
        loginUseCase.execute(loginProvider: .google)
            .sink { [unowned self] completion in
                self.state.isLoading = false
                
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
    
    private func handleLogout() {
        state.isLoading = true
        
        logoutUseCase.execute()
            .sink { completion in
                self.state.isLoading = false
                
                switch completion {
                case .finished:
                    print("✅ Logout Network Success")
                case .failure(let error):
                    print("⛔️ Logout Network Error: \(error)")
                }
            } receiveValue: { [weak self] result in
                if result {
                    self?.state.authenticationState = .unauthenticated
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleUnlink() {
        state.isLoading = true
        
        unlinkUseCase.execute()
            .sink { completion in
                self.state.isLoading = false
                
                switch completion {
                case .finished:
                    print("✅ Unlink Success")
                case .failure(let error):
                    print("⛔️ Unlink Error: \(error)")
                }
            } receiveValue: { [weak self] result in
                if result {
                    self?.state.authenticationState = .unauthenticated
                }
            }
            .store(in: &cancellables)
    }
}
