//
//  ProfileView.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/2/25.
//

import SwiftUI

struct ProfileView: View {
    private let user: User
    
    init(user: User) {
        self.user = user
    }

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
        } leaddingView: {
            EmptyView()
        } trailingView: {
            Image(.tjSetting)
        }
    }
}

extension ProfileView {
    private var profileInfoView: some View {
        HStack(spacing: 15) {
            ProfileImageView(
                viewType: .profileInfo,
                image: Image("\(user.profileImageURLString)")
            )
            
            VStack(alignment: .leading) {
                HStack(spacing: 6) {
                    Text("\(user.nickname)")
                        .font(.pretendardSemiBold(16))
                    Image(user.accountScope.imageResourceString)
                        .frame(width: 16, height: 16)
                }
                
                ActivityOverview(
                    user: user,
                    isCurrentUser: true
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
            MenuHorizontalView(text: "프로필 수정") { }
            MenuHorizontalView(text: "좋아요한 여행 일지") { }
            MenuHorizontalView(text: "저장한 여행 일지") { }
            MenuHorizontalView(text: "차단 회원 관리") { }
        }
    }
}

#Preview {
    ProfileView(user: .init(
        nickname: "닉네임",
        profileImageURLString: "",
        accountScope: .followersOnly,
        followingCount: 70,
        followerCount: 99,
        travelJournalCount: 3,
        placesCount: 33,
        isFirstLogin: false,
        regionDatas: []
    ))
}
