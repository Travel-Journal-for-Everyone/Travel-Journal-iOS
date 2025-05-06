//
//  ExploreView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/2/25.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel: ExploreViewModel
    
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            CustomSegmentedControl(
                options: ["여행 일지", "플레이스"],
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
                    journalListView
                        .containerRelativeFrame(.horizontal)
                        .contentMargins(.horizontal, 16)
                        .contentMargins(.bottom, 63.adjustedH)
                        .id(0)
                        .onAppear {
                            if viewModel.state.isJournalsInitialLoading {
                                viewModel.send(.journalListViewOnAppear)
                            }
                        }
                    
                    placeGridView
                        .containerRelativeFrame(.horizontal)
                        .contentMargins(.horizontal, 16)
                        .id(1)
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
            Text("탐험하기")
                .font(.pretendardMedium(16))
                .foregroundStyle(.tjBlack)
        }
    }
    
    @ViewBuilder
    private var journalListView: some View {
        if viewModel.state.isJournalsInitialLoading {
            ProgressView()
        } else {
            if viewModel.state.journalSummaries.isEmpty {
                VStack(spacing: 12) {
                    Text("탐험할 여행 일지가 없습니다.")
                        .font(.pretendardMedium(16))
                        .foregroundStyle(.tjGray2)
                    
                    RefreshButton {
                        viewModel.send(.refreshJournals)
                    }
                }
            } else {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 15) {
                        Color.clear
                            .frame(height: 5)
                        
                        ForEach(viewModel.state.journalSummaries, id: \.id) { exploreJournalSummary in
                            ExploreJournalListCell(exploreJournalSummary)
                                .contentShape(.rect)
                                .onTapGesture {
                                    print("\(exploreJournalSummary.id)")
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
                .contentMargins(.bottom, 54.adjustedH, for: .scrollIndicators)
                .contentMargins(0, for: .scrollIndicators)
            }
        }
    }
    
    private var placeGridView: some View {
        Text("플레이스 그리드 뷰")
    }
}

#Preview {
    //ExploreView(viewModel: .init())
    
    MainTabView()
        .environmentObject(DefaultCoordinator())
}
