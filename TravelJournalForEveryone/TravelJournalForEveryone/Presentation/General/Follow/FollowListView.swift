//
//  FollowListView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/2/25.
//

import SwiftUI

struct FollowListView: View {
    @StateObject var viewModel: FollowListViewModel
    @EnvironmentObject private var coordinator: DefaultCoordinator
    
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            CustomSegmentedControl(
                options: [
                    "팔로워 \(viewModel.state.folloewrCount)",
                    "팔로잉 \(viewModel.state.followingCount)"
                ],
                selectedIndex: Binding(
                    get: { viewModel.state.selectedSegmentIndex },
                    set: { viewModel.send(.selectSegment($0)) }
                ),
                namespace: namespace
            )
            .padding(.horizontal, 16)
            .padding(.top, 15)
            
            TabView(selection: Binding(
                get: { viewModel.state.selectedSegmentIndex },
                set: { viewModel.send(.selectSegment($0)) }
            )) {
                followerListView
                    .tag(0)
                    .onAppear {
                        viewModel.send(.followerListViewOnAppear)
                    }
                
                followingListView
                    .tag(1)
                    .onAppear {
                        viewModel.send(.followingListViewOnAppear)
                    }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .contentMargins(.horizontal, 16)
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .customNavigationBar {
            Text(viewModel.state.userNickname)
                .font(.pretendardMedium(16))
                .foregroundStyle(.tjBlack)
        } leadingView: {
            Button {
                coordinator.pop()
            } label: {
                Image(.tjLeftArrow)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
    }
    
    private var followerListView: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                Color.clear
                    .frame(height: 5)
                
                if viewModel.state.followingRequestUsers.isEmpty {
                    EmptyView()
                } else {
                    HStack {
                        Text("요청 (\(viewModel.state.followingRequestUserCount))")
                            .font(.pretendardMedium(16))
                            .foregroundStyle(.tjBlack)
                        
                        Spacer()
                    }
                    
                    ForEach(viewModel.state.followingRequestUsers, id: \.self) { userSummary in
                        UserSummaryView(
                            userSummary: userSummary,
                            viewType: .followingRequest(onAccept: {
                                viewModel.send(.tappedFollowingAcceptButton)
                            }, onReject: {
                                viewModel.send(.tappedFollowingRejectButton)
                            })
                        )
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.tjGray5)
                        .padding(.vertical, 5)
                }
                
                ForEach(viewModel.state.followers, id: \.self) { userSummary in
                    UserSummaryView(
                        userSummary: userSummary,
                        viewType: .follow(onUnfollow: {
                            viewModel.send(.tappedUnfollowButton)
                        })
                    )
                }
            }
        }
        .scrollIndicators(.never)
    }
    
    @ViewBuilder
    private var followingListView: some View {
        if viewModel.state.followings.isEmpty {
            // TODO: - EmptyView 구현
            Text("팔로잉하는 여행자가 없습니다.")
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 15) {
                    Color.clear
                        .frame(height: 5)
                    
                    ForEach(viewModel.state.followings, id: \.self) { userSummary in
                        UserSummaryView(
                            userSummary: userSummary,
                            viewType: .follow(onUnfollow: {
                                viewModel.send(.tappedUnfollowButton)
                            })
                        )
                    }
                }
            }
            .scrollIndicators(.never)
        }
    }
}

#Preview {
    FollowListView(
        viewModel: .init(
            userNickname: "마루김마루",
            folloewrCount: 23,
            followingCount: 77,
            viewType: .follower
        )
    )
}
