//
//  ActivityOverview.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/2/25.
//

import SwiftUI

struct ActivityOverview: View {
    @EnvironmentObject private var coordinator: DefaultCoordinator
    
    private let user: User
    private let isCurrentUser: Bool
    private let travelJournalAction: () -> Void
    private let placeAction: () -> Void
    
    init(
        user: User,
        isCurrentUser: Bool,
        travelJournalAction: @escaping () -> Void,
        placeAction: @escaping () -> Void
    ) {
        self.user = user
        self.isCurrentUser = isCurrentUser
        self.travelJournalAction = travelJournalAction
        self.placeAction = placeAction
    }
    
    var body: some View {
        HStack {
            textNumberVerticalView(title: "팔로워", number: user.followerCount)
                .onTapGesture {
                    if user.accountScope != .privateProfile || isCurrentUser {
                        coordinator.push(.followList)
                    }
                }
            Spacer()
            
            textNumberVerticalView(title: "팔로잉", number: user.followingCount)
                .onTapGesture {
                    if user.accountScope != .privateProfile || isCurrentUser {
                        coordinator.push(.followList)
                    }
                }
            Spacer()
            
            textNumberVerticalView(title: "여행일지", number: user.travelJournalCount)
                .onTapGesture {
                    if user.accountScope != .privateProfile || isCurrentUser {
                        travelJournalAction()
                    }
                }
            Spacer()
            
            textNumberVerticalView(title: "플레이스", number: user.placesCount)
                .onTapGesture {
                    if user.accountScope != .privateProfile || isCurrentUser {
                        placeAction()
                    }
                }
        }
    }
    
    private func textNumberVerticalView(
        title: String,
        number: Int
    ) -> some View {
        VStack(spacing: 10) {
            Text("\(title)")
                .font(.pretendardRegular(12))
            
            if user.accountScope == .privateProfile && !isCurrentUser {
                Image(.tjLock)
                    .resizable()
                    .frame(width: 16, height: 16)
            } else {
                Text("\(number)")
                    .font(.pretendardSemiBold(16))
            }
        }
    }
}

#Preview {
    ActivityOverview(
        user: .mock(),
        isCurrentUser: true,
        travelJournalAction: { },
        placeAction: { }
    )
    .environmentObject(DefaultCoordinator())
}
