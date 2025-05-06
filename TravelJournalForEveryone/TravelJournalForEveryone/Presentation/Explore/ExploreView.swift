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
                        .contentMargins(.bottom, 63.adjustedH)
                        .id(1)
                        .onAppear {
                            if viewModel.state.isPlacesInitialLoading {
                                viewModel.send(.placeGridViewOnAppear)
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
    
    @ViewBuilder
    private var placeGridView: some View {
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: 5),
            count: 2
        )
        
        if viewModel.state.isPlacesInitialLoading {
            ProgressView()
        } else {
            if viewModel.state.placesSummaries.isEmpty {
                VStack(spacing: 12) {
                    Text("탐험할 플레이스가 없습니다.")
                        .font(.pretendardMedium(16))
                        .foregroundStyle(.tjGray2)
                    
                    RefreshButton {
                        viewModel.send(.refreshPlaces)
                    }
                }
            } else {
                ScrollView(.vertical) {
                    Color.clear
                        .frame(height: 10)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.state.placesSummaries) { placeSummary in
                            PlaceGridCell(placeSummary)
                                .contentShape(.rect)
                                .onTapGesture {
                                    print("\(placeSummary.id)")
                                }
                        }
                        
                        if !viewModel.state.isLastPlacesPage {
                            ProgressView()
                            ProgressView()
                                .task {
                                    viewModel.send(.placeGridNextPageOnAppear)
                                }
                        }
                    }
                }
                .refreshable {
                    viewModel.send(.refreshPlaces)
                }
                .scrollIndicators(.visible)
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
