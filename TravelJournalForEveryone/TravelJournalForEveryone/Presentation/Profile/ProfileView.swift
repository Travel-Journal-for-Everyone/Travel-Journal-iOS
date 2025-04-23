//
//  ProfileView.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/2/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var coordinator: DefaultCoordinator
    @StateObject var viewModel: ProfileTabViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            profileInfoView
                .padding(.bottom, 20)
            
            menuSectionView
            
            Spacer()
        }
        .padding(.horizontal, 25)
        .padding(.top, 25)
        .customNavigationBar {
            Text("프로필")
                .font(.pretendardMedium(17))
        } leadingView: {
            EmptyView()
        } trailingView: {
            Image(.tjSetting)
        }
        .onAppear {
            viewModel.send(.viewOnAppear)
        }
    }
}

extension ProfileView {
    private var profileInfoView: some View {
        HStack(spacing: 15) {
            ProfileImageView(
                viewType: .profileInfo,
                imageString: viewModel.state.user.profileImageURLString
            )
            
            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 6) {
                    Text("\(viewModel.state.user.nickname)")
                        .font(.pretendardSemiBold(16))
                    Image(viewModel.state.user.accountScope.imageResourceString)
                        .frame(width: 16, height: 16)
                }
                
                ActivityOverview(
                    user: viewModel.state.user,
                    isCurrentUser: true,
                    memberID: nil
                ) {
                    print("일지 리스트")
                } placeAction: {
                    print("플레이스 리스트")
                }
            }
        }
    }
    
    private var menuSectionView: some View {
        VStack(spacing: 0) {
            Divider()
                .foregroundStyle(.tjGray6)
            MenuHorizontalView(text: "프로필 수정") {
                coordinator.push(.profileFix)
            }
            MenuHorizontalView(text: "좋아요한 여행 일지") { }
            MenuHorizontalView(text: "저장한 여행 일지") { }
            MenuHorizontalView(text: "차단 회원 관리") { }
        }
    }
}

#Preview {
    ProfileView(viewModel: .init())
}
