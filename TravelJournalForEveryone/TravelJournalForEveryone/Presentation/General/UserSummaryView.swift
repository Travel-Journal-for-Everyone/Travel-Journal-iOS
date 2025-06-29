//
//  UserSummaryView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/9/25.
//

import SwiftUI

enum UserSummaryViewType {
    case basic
    case follow(onUnfollow: () -> Void)
    case followingRequest(onAccept: () -> Void, onReject: () -> Void)
    case journalOrPlace(isFollowing: Bool, action: () -> Void)
    case searching
    case blocking(onUnblock: () -> Void)
}

struct UserSummaryView: View {
    private let userSummary: UserSummary
    private let viewType: UserSummaryViewType
    
    init(
        userSummary: UserSummary,
        viewType: UserSummaryViewType
    ) {
        self.userSummary = userSummary
        self.viewType = viewType
    }
    
    var body: some View {
        HStack(spacing: 10) {
            ProfileImageView(
                viewType: .listCell,
                imageString: userSummary.profileImageURLString
            )
            
            VStack(alignment: .leading, spacing: 5) {
                Text(userSummary.nickname)
                    .font(.pretendardMedium(16))
                    .foregroundStyle(.tjBlack)
                
                switch viewType {
                case .blocking:
                    EmptyView()
                default:
                    HStack(spacing: 5) {
                        HStack(spacing: 2) {
                            Image(.tjJournal)
                                .frame(width: 16, height: 16)
                            Text("\(userSummary.travelJournalCount ?? 0)")
                                .font(.pretendardRegular(12))
                        }
                        
                        HStack(spacing: 2) {
                            Image(.tjPlace)
                                .frame(width: 16, height: 16)
                            Text("\(userSummary.placeCount ?? 0)")
                                .font(.pretendardRegular(12))
                        }
                    }
                    .foregroundStyle(.tjGray2)
                }
            }
            
            Spacer()
            
            trailingView
        }
    }
    
    @ViewBuilder
    private var trailingView: some View {
        switch viewType {
        case .basic, .searching:
            EmptyView()
        case .follow(let onUnfollow):
            Button {
                onUnfollow()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(.tjBlack)
            }
        case .followingRequest(let onAccept, let onReject):
            HStack(spacing: 5) {
                Button {
                    onAccept()
                } label: {
                    Text("수락")
                        .foregroundStyle(.tjWhite)
                        .font(.pretendardMedium(12))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.tjPrimaryMain)
                        }
                }
                
                Button {
                    onReject()
                } label: {
                    Text("거절")
                        .foregroundStyle(.tjBlack)
                        .font(.pretendardMedium(12))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(.tjGray4, lineWidth: 1)
                                .foregroundStyle(.white)
                        }
                }
            }
        case .journalOrPlace(let isFollowing, let action):
            FollowButton(isFollowing: isFollowing) {
                action()
            }
        case .blocking(let onCancel):
            Button {
                onCancel()
            } label: {
                Text("해제")
                    .foregroundStyle(.tjBlack)
                    .font(.pretendardMedium(12))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(.tjGray4, lineWidth: 1)
                            .foregroundStyle(.white)
                    }
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        UserSummaryView(userSummary: .mock(id: 0, nickname: "마루김마루"), viewType: .follow(onUnfollow: {}))
        
        UserSummaryView(userSummary: .mock(id: 0, nickname: "마루김마루"), viewType: .followingRequest(onAccept: {}, onReject: {}))
        
        UserSummaryView(userSummary: .mock(id: 0, nickname: "마루김마루"), viewType: .journalOrPlace(isFollowing: false, action: {}))
        
        UserSummaryView(userSummary: .mock(id: 0, nickname: "마루김마루"), viewType: .searching)
        
        UserSummaryView(userSummary: .mock(id: 0, nickname: "마루김마루"), viewType: .blocking(onUnblock: {}))
    }
    .padding(.horizontal, 16)
}
