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
                    "팔로워 \(viewModel.state.followerCount)",
                    "팔로잉 \(viewModel.state.followingCount)"
                ],
                selectedIndex: Binding(
                    get: { viewModel.state.selectedSegmentIndex },
                    set: { newIndex in
                        withAnimation {
                            viewModel.send(.selectSegment(newIndex))
                        }
                    }
                ),
                namespace: namespace
            )
            .padding(.horizontal, 16)
            .padding(.top, 15)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 32) {
                    followerListView
                        .containerRelativeFrame(.horizontal)
                        .contentMargins(.horizontal, 16)
                        .id(0)
                        .onAppear {
                            if viewModel.state.isFollowersInitialLoading {
                                viewModel.send(.followerListViewOnAppear)
                            }
                        }
                    
                    followingListView
                        .containerRelativeFrame(.horizontal)
                        .contentMargins(.horizontal, 16)
                        .id(1)
                        .onAppear {
                            if viewModel.state.isFollowingsInitialLoading {
                                viewModel.send(.followingListViewOnAppear)
                            }
                        }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: Binding(
                get: { viewModel.state.selectedSegmentIndex },
                set: { viewModel.send(.selectSegment($0 ?? 0)) }
            ))
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
    
    @ViewBuilder
    private var followerListView: some View {
        if viewModel.state.isFollowersInitialLoading {
            ProgressView()
        } else {
            if viewModel.state.followers.isEmpty && viewModel.state.followingRequestUsers.isEmpty {
                Text("팔로워 중인 여행자가 없습니다.")
                    .font(.pretendardMedium(16))
                    .foregroundStyle(.tjGray2)
            } else {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 15) {
                        Color.clear
                            .frame(height: 5)
                        
                        if viewModel.state.isCurrentUser {
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
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        coordinator.push(.myJournal(memberID: userSummary.id))
                                    }
                                }
                                
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundStyle(.tjGray5)
                                    .padding(.vertical, 5)
                            }
                        }
                        
                        ForEach(viewModel.state.followers, id: \.id) { userSummary in
                            Group {
                                if viewModel.state.isCurrentUser {
                                    UserSummaryView(
                                        userSummary: userSummary,
                                        viewType: .follow(onUnfollow: {
                                            // TODO: - 팔로워 X 버튼 Action
                                        })
                                    )
                                } else {
                                    UserSummaryView(
                                        userSummary: userSummary,
                                        viewType: .basic
                                    )
                                }
                            }
                            .contentShape(.rect)
                            .onTapGesture {
                                coordinator.push(.myJournal(memberID: userSummary.id))
                            }
                        }
                        
                        if !viewModel.state.isLastFollowersPage {
                            ProgressView()
                                .task {
                                    viewModel.send(.followerListNextPageOnAppear)
                                }
                        }
                    }
                }
                .scrollIndicators(.visible)
                .contentMargins(.bottom, 1.adjustedH, for: .scrollIndicators)
                .contentMargins(0, for: .scrollIndicators)
            }
        }
    }
    
    @ViewBuilder
    private var followingListView: some View {
        if viewModel.state.isFollowingsInitialLoading {
            ProgressView()
        } else {
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
                            Group {
                                if viewModel.state.isCurrentUser {
                                    UserSummaryView(
                                        userSummary: userSummary,
                                        viewType: .follow(onUnfollow: {
                                            viewModel.send(.tappedUnfollowButton(memberID: userSummary.id))
                                        })
                                    )
                                } else {
                                    UserSummaryView(
                                        userSummary: userSummary,
                                        viewType: .basic
                                    )
                                }
                            }
                            .contentShape(.rect)
                            .onTapGesture {
                                coordinator.push(.myJournal(memberID: userSummary.id))
                            }
                        }
                        
                        if !viewModel.state.isLastFollowingsPage {
                            ProgressView()
                                .task {
                                    viewModel.send(.followingListNextPageOnAppear)
                                }
                        }
                    }
                    .animation(.easeIn, value: viewModel.state.followings)
                }
                .scrollIndicators(.visible)
                .contentMargins(.bottom, 1.adjustedH, for: .scrollIndicators)
                .contentMargins(0, for: .scrollIndicators)
            }
        }
    }
}

#Preview {
    FollowListView(
        viewModel: .init(
            fetchFollowCountUseCase: DIContainer.shared.fetchFollowCountUseCase,
            fetchFollowersUseCase: DIContainer.shared.fetchFollowersUseCase,
            fetchFollowingsUseCase: DIContainer.shared.fetchFollowingsUseCase,
            unfollowUseCase: DIContainer.shared.unfollowUseCase,
            memberID: 10,
            isCurrentUser: true,
            nickname: "몽그리바보",
            viewType: .follower
        )
    )
}
