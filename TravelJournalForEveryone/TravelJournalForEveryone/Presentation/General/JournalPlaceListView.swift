//
//  JournalPlaceListView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/2/25.
//

import SwiftUI

struct JournalPlaceListView: View {
    @StateObject var viewModel: JournalPlaceListViewModel
    
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.state.viewType {
            case .all, .region, .save:
                CustomSegmentedControl(
                    options: [
                        "여행 일지 \(viewModel.state.journalSummariesCount)",
                        "플레이스 \(viewModel.state.placeSummariesCount)"
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
                    journalListView()
                        .tag(0)
                        .task {
                            if viewModel.state.isJournalsInitialLoading {
                                viewModel.send(.journalListViewOnAppear)
                            }
                        }
                    
                    placeGridView()
                        .tag(1)
                        .task {
                            if viewModel.state.isPlacesInitialLoading {
                                viewModel.send(.placeGridViewOnAppear)
                            }
                        }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .contentMargins(.horizontal, 16)
                .contentMargins(0, for: .scrollIndicators)
                .ignoresSafeArea(.all, edges: .bottom)
            case .like:
                journalListView()
                    .padding(.horizontal, 16)
                    .onAppear {
                        viewModel.send(.journalListViewOnAppear)
                    }
            }
        }
        .customNavigationBar {
            Text(viewModel.state.navigationTitle)
                .font(.pretendardMedium(16))
                .foregroundStyle(.tjBlack)
        } leadingView: {
            switch viewModel.state.viewType {
            case .all, .region:
                EmptyView()
            case .save, .like:
                Button {
                    
                } label: {
                    Image(.tjLeftArrow)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
    
    @ViewBuilder
    private func journalListView() -> some View {
        if viewModel.state.isJournalsInitialLoading {
            ProgressView()
        } else {
            if viewModel.state.journalSummaries.isEmpty {
                Text("작성된 여행 일지가 없습니다.")
                    .font(.pretendardMedium(16))
                    .foregroundStyle(.tjGray2)
            } else {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 15) {
                        Color.clear
                            .frame(height: 5)
                        
                        ForEach(viewModel.state.journalSummaries, id: \.id) { journalSummary in
                            JournalListCell(journalSummary)
                        }
                        
                        if !viewModel.state.isLastJournalsPage {
                            ProgressView()
                                .task {
                                    viewModel.send(.journalListNextPageOnAppear)
                                }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func placeGridView() -> some View {
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: 5),
            count: 2
        )
        
        if viewModel.state.isPlacesInitialLoading {
            ProgressView()
        } else {
            if viewModel.state.placeSummaries.isEmpty {
                Text("등록된 플레이스가 없습니다.")
                    .font(.pretendardMedium(16))
                    .foregroundStyle(.tjGray2)
            } else {
                ScrollView(.vertical) {
                    Color.clear
                        .frame(height: 10)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.state.placeSummaries, id: \.id) { placeSummary in
                            PlaceGridCell(placeSummary)
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
            }
        }
    }
}

#Preview {
    JournalPlaceListView(
        viewModel: .init(
            fetchJournalsUseCase: DIContainer.shared.fetchJournalsUseCase,
            fetchPlacesUseCase: DIContainer.shared.fetchPlacesUseCase,
            user: .mock(),
            viewType: .region(.gyeongsang)
            //viewType: .like
            //viewType: .save
        )
    )
}
