//
//  BlockedUserListView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/13/25.
//

import SwiftUI

struct BlockedUserListView: View {
    @StateObject var viewModel: BlockedUserListViewModel
    @EnvironmentObject private var coordinator: DefaultCoordinator
    
    @State private var isShowingAlert: Bool = false
    
    var body: some View {
        Group {
            if viewModel.state.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                if viewModel.state.blockedUsers.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        
                        Text("차단한 여행자가 없습니다.")
                            .font(.pretendardMedium(16))
                            .foregroundStyle(.tjGray2)
                        
                        RefreshButton {
                            viewModel.send(.refreshList)
                        }
                        
                        Spacer()
                    }
                } else {
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.state.blockedUsers, id: \.id) { userSummary in
                                UserSummaryView(
                                    userSummary: userSummary,
                                    viewType: .blocking(
                                        onUnblock: {
                                            viewModel.send(
                                                .selectedUser(
                                                    nickname: userSummary.nickname,
                                                    id: userSummary.id
                                                )
                                            )
                                            isShowingAlert.toggle()
                                        })
                                )
                                .contentShape(.rect)
                                .onTapGesture {
                                    // TODO: - 여행자 프로필 뷰로 이동
                                    print("여행자(ID: \(userSummary.id)) 프로필로 이동")
                                }
                            }
                            
                            if !viewModel.state.isLastPage {
                                ProgressView()
                                    .task {
                                        viewModel.send(.listNextPageOnAppear)
                                    }
                            }
                        }
                    }
                    .refreshable {
                        viewModel.send(.refreshList)
                    }
                    .scrollIndicators(.visible)
                    .contentMargins(.horizontal, 16)
                    .contentMargins(.vertical, 20)
                    .contentMargins(.bottom, 1.adjustedH, for: .scrollIndicators)
                    .contentMargins(0, for: .scrollIndicators)
                }
            }
        }
        .customNavigationBar {
            Text("차단 회원 관리")
                .font(.pretendardMedium(17))
                .foregroundStyle(.tjBlack)
        } leadingView: {
            Image(.tjLeftArrow)
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    coordinator.pop()
                }
        }
        .customAlert(
            isPresented: $isShowingAlert,
            alertType: .unblockedUser(nickname: "\(viewModel.state.selectedUserNickname ?? "")"),
            action: { viewModel.send(.unblockedUser) }
        )
        .onAppear {
            viewModel.send(.listViewOnAppear)
        }
    }
}

#Preview {
    BlockedUserListView(viewModel: .init())
}
