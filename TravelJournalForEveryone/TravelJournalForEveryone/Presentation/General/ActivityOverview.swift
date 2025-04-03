//
//  ActivityOverview.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/2/25.
//

import SwiftUI

struct ActivityOverview: View {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        HStack {
            textNumberVerticalView(title: "팔로워", number: user.followerCount)
            Spacer()
            textNumberVerticalView(title: "팔로잉", number: user.followingCount)
            Spacer()
            textNumberVerticalView(title: "여행일지", number: user.travelJournalCount)
            Spacer()
            textNumberVerticalView(title: "플레이스", number: user.placesCount)
        }
    }
    
    private func textNumberVerticalView(
        title: String,
        number: Int
    ) -> some View {
        VStack(spacing: 10) {
            Text("\(title)")
                .font(.pretendardRegular(12))
            Text("\(number)")
                .font(.pretendardSemiBold(16))
        }
    }
}

#Preview {
    ActivityOverview(
        user: .init(
            nickname: "",
            profileImageURLString: "",
            accountScope: .followersOnly,
            followingCount: 0,
            followerCount: 0,
            travelJournalCount: 0,
            placesCount: 0,
            isFirstLogin: false,
            regionDatas: []
        )
    )
}
