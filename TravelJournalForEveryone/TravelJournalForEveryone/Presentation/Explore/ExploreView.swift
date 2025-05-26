//
//  ExploreView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/2/25.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel: ExploreViewModel
    
    var body: some View {
        journalListView
            .contentMargins(.horizontal, 16)
            .contentMargins(.bottom, 63.adjustedH)
            .onAppear {
                if viewModel.state.isJournalsInitialLoading {
                    viewModel.send(.journalListViewOnAppear)
                }
            }
            .customNavigationBar {
                Text("탐험하기")
                    .font(.pretendardMedium(16))
                    .foregroundStyle(.tjBlack)
            }
            .onDisappear {
                viewModel.send(.journalListViewOnDisappear)
            }
    }
    
    @ViewBuilder
    private var journalListView: some View {
        if viewModel.state.isJournalsInitialLoading {
            Spacer()
            ProgressView()
            Spacer()
        } else {
            if viewModel.state.journalSummaries.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    
                    Text("탐험할 여행 일지가 없습니다.")
                        .font(.pretendardMedium(16))
                        .foregroundStyle(.tjGray2)
                    
                    RefreshButton {
                        viewModel.send(.refreshJournals)
                    }
                    
                    Spacer()
                }
            } else {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.state.journalSummaries, id: \.id) { exploreJournalSummary in
                            ExploreJournalListCell(exploreJournalSummary)
                                .contentShape(.rect)
                                .onTapGesture {
                                    print("\(exploreJournalSummary.id)")
                                }
                                .onAppear {
                                    viewModel.send(.seeJournal(id: exploreJournalSummary.id))
                                }
                        }
                        
                        if !viewModel.state.isLastJournalsPage {
                            ProgressView()
                                .task {
                                    viewModel.send(.journalListNextPageOnAppear)
                                }
                        }
                    }
                }
                .refreshable {
                    viewModel.send(.refreshJournals)
                }
                .scrollIndicators(.visible)
                .contentMargins(.top, 20.adjustedH)
                .contentMargins(.bottom, 54.adjustedH, for: .scrollIndicators)
                .contentMargins(0, for: .scrollIndicators)
            }
        }
    }
}

#Preview {
    //ExploreView(viewModel: .init())
    
    MainTabView()
        .environmentObject(DefaultCoordinator())
}
