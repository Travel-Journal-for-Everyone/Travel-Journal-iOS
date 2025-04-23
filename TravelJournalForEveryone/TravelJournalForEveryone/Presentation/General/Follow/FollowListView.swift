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
            Text(viewModel.state.nickname)
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
        .onAppear {
            viewModel.send(.listViewOnAppear)
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
                    
                    ForEach(viewModel.state.followingRequestUsers, id: \.id) { userSummary in
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
                
                // TODO: - Fetch API 적용할 때, EmptyView 구현하기
                ForEach(viewModel.state.followers, id: \.id) { userSummary in
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
            Text("팔로잉 중인 여행자가 없습니다.")
                .font(.pretendardMedium(16))
                .foregroundStyle(.tjGray2)
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 15) {
                    Color.clear
                        .frame(height: 5)
                    
                    ForEach(viewModel.state.followings, id: \.id) { userSummary in
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
            fetchFollowCountUseCase: DIContainer.shared.fetchFollowCountUseCase,
            memberID: 10,
            nickname: "몽그리바보",
            viewType: .follower
        )
    )
}
