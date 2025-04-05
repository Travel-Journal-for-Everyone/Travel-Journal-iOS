//
//  FollowButton.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/3/25.
//

import SwiftUI

struct FollowButton: View {
    var isFollowing: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            if isFollowing {
                Text("팔로잉")
                    .foregroundStyle(.tjPrimaryMain)
                    .font(.pretendardMedium(12))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(.tjPrimaryLight, lineWidth: 1)
                            .foregroundStyle(.white)
                        
                    }
            } else {
                Text("팔로우")
                    .foregroundStyle(.tjWhite)
                    .font(.pretendardMedium(12))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.tjPrimaryMain)
                    }
            }
        }
    }
}

#Preview {
    VStack {
        FollowButton(isFollowing: true) { }
        FollowButton(isFollowing: false) { }
    }
}
