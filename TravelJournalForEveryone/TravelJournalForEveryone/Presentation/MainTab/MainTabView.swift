//
//  MainTabView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    private let userInfoManager = DIContainer.shared.userInfoManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("MainTabView")
            
            AsyncImage(url: URL(string: userInfoManager.profileImageURLString)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 150)
            
            Text("\(userInfoManager.nickname)")
            Text("\(userInfoManager.accounScope)")
            
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
