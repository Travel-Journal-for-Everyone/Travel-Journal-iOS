//
//  MainTabView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("MainTabView")
            
            Text("Logout")
                .onTapGesture {
                    viewModel.send(.logout)
                }
            
            Text("Unlink")
                .onTapGesture {
                    viewModel.send(.unlink)
                }
        }
    }
}

#Preview {
    MainTabView()
}
