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
            // TODO:
            break
        case .kakaoLogin:
            print("kakaoLogin")
            loginUsecase.loginWith(.kakao)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.state.isPresentedProfileCreationView = true
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: { token in
                    // TODO: - token 처리
                }
                .store(in: &cancellables)
            
        case .appleLogin:
            print("appleLogin")
        case .googleLogin:
            print("googleLogin")
            state.isPresentedProfileCreationView = true
        case .isPresentedProfileCreationView(let value):
            state.isPresentedProfileCreationView = value
        case .logout:
            // TODO:
            break
        }
    }
}
