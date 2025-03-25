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
        VStack {
            Text("MainTabView")
            
            Text("Logout")
                .onTapGesture {
                    viewModel.send(.logout)
                }
        }
    }
}

#Preview {
    MainTabView()
}
