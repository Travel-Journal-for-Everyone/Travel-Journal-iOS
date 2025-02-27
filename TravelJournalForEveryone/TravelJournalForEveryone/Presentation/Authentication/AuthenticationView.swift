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
            }
        }
        .onAppear {
            viewModel.send(.viewOnAppear)
        }
    }
}

#Preview {
    AuthenticationView(viewModel: .init(
        loginUsecase: DIContainer.shared.loginUsecase)
    )
}
