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
        loginUsecase.execute(loginType: .kakao)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    self.state.isPresentedProfileCreationView = true
                case .failure(let error):
                    print("Kakao Login Error: \(error.localizedDescription)")
                }
            } receiveValue: { idToken in
                // TODO: - idToken 처리
                guard let idToken else {
                    print("Kakao Login Error: ID Token 없음")
                    return
                }
                
                _ = idToken
            }
            .store(in: &cancellables)
    }
    
    private func handleAppleLogin() {
        loginUsecase.execute(loginType: .apple)
            .sink {  completion in
                switch completion {
                case .finished:
                    print("apple login success")
                case .failure(let error):
                    print("Apple Login Error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] token in
                // 임시
                guard let self else { return }
                if let token {
                    self.state.isPresentedProfileCreationView = true
                }
                return
            }
            .store(in: &cancellables)
    }
    
    private func handleGoogleLogin() {
        print("googleLogin")
        // 임시 테스트
        state.isPresentedProfileCreationView = true
    }
    
    private func handleLogout() { }
}
