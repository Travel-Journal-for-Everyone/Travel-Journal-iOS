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
                        "플레이스\(viewModel.state.placeSummariesCount)"
                    ],
                    selectedIndex: Binding(
                        get: { viewModel.state.selectedSegmentIndex },
                        set: { viewModel.send(.selectSegment($0)) }
                    ),
                    namespace: namespace
                )
            case .like:
                EmptyView()
            }
            
            if viewModel.state.selectedSegmentIndex == 0 {
                journalListView()
                    .onAppear {
                        viewModel.send(.journalListViewOnAppear)
                    }
            } else {
                placeGridView()
                    .onAppear {
                        viewModel.send(.placeGridViewOnAppear)
                    }
            }
        }
        .padding(.horizontal, 16)
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
        if viewModel.state.journalSummaries.isEmpty {
            // TODO: - EmptyView 구현
            Spacer()
            Text("작성된 여행 일지가 없습니다.")
            Spacer()
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 15) {
                    Color.clear
                        .frame(height: 5)
                    
                    ForEach(viewModel.state.journalSummaries, id: \.self) { journalSummary in
                        JournalListCell(journalSummary)
                    }
                }
            }
            .scrollIndicators(.never)
        }
    }
    
    @ViewBuilder
    private func placeGridView() -> some View {
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: 5),
            count: 2
        )
        
        if viewModel.state.placeSummaries.isEmpty {
            // TODO: - EmptyView 구현
            Spacer()
            Text("등록된 플레이스가 없습니다.")
            Spacer()
        } else {
            ScrollView(.vertical) {
                Color.clear
                    .frame(height: 10)
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.state.placeSummaries, id: \.self) { placeSummary in
                        PlaceGridCell(placeSummary)
                    }
                }
            }
            .scrollIndicators(.never)
        }
    }
}

#Preview {
    JournalPlaceListView(
        viewModel: .init(
            viewType: .region(.gyeongsang)
            //viewType: .like
            //viewType: .save
        )
    )
}
