//
//  AuthenticationView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            switch authViewModel.state.authenticationState {
            case .unauthenticated:
                LoginView()
                    .environmentObject(authViewModel)
            case .authenticated:
                MainTabView()
            }
        }
        .onAppear {
            authViewModel.send(.viewOnAppear)
        }
    }
}

#Preview {
    AuthenticationView(authViewModel: .init())
}
