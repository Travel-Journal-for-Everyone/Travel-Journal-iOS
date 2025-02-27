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
            loginUsecase.execute(loginType: .kakao)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.state.isPresentedProfileCreationView = true
                    case .failure(let error):
                        print("Kakao Login Error: \(error.localizedDescription)")
                    }
                } receiveValue: { idToken in
                    // TODO: - idToken 처리, 아마 이 부분은 나중에 private 함수로 처리할 예정!
                    guard let idToken else {
                        print("Kakao Login Error: ID Token 없음")
                        return
                    }
                    
                    _ = idToken
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
