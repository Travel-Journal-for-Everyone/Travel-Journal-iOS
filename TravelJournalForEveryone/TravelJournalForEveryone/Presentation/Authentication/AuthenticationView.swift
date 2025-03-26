//
//  AuthenticationView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject var coordinator = DefaultCoordinator()
    @StateObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            switch viewModel.state.authenticationState {
            case .unauthenticated:
                LoginView()
                    .environmentObject(viewModel)
            case .authenticated:
                MainTabView()
                    .environmentObject(coordinator)
                    .environmentObject(viewModel)
            }
        }
        .onAppear {
            viewModel.send(.authenticationViewOnAppear)
        }
    }
}

#Preview {
    AuthenticationView(viewModel: .init(
        loginUseCase: DIContainer.shared.loginUseCase,
        logoutUseCase: DIContainer.shared.logoutUseCase,
        authStateCheckUseCase: DIContainer.shared.authStateCheckUseCase
    ))
}
