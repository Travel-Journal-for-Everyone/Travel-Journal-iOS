//
//  SearchView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/2/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @Namespace var namespace
    @FocusState private var focused: Bool 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            searchBar(viewModel.state.searchText)
            switch viewModel.state.searchState {
            case .beforeSearch:
                if viewModel.state.recentSearchList.isEmpty {
                    emptyView
                } else {
                    recentSearchHeader
                    recentSearchContent
                }
            case .searching:
                Spacer()
            case .successSearch:
                searchResultView
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .onAppear {
            viewModel.send(.viewOnAppear)
        }
    }
}

extension SearchView {
    private func searchBar(_ text: String) -> some View {
        HStack {
            TextField(
                "",
                text: Binding(
                    get: { viewModel.state.searchText },
                    set: { viewModel.send(.enterSearchText($0)) }
                )
            )
            .font(.pretendardRegular(16))
            .focused($focused)
            .placeholder(when: text.isEmpty) {
                Text("궁금한 여행지를 검색해보세요!")
                    .font(.pretendardRegular(16))
                    .foregroundStyle(.tjGray3)
            }
            .onSubmit {
                viewModel.send(.onSubmit)
            }
            
            Spacer()
            
            Image(text.isEmpty ? .tjSearch : .tjClose)
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    viewModel.send(.deleteSearchText)
                }
        }
        .padding(.horizontal, 20)
        .frame(height: 44.adjustedH)
        .background(.tjGray6, in: RoundedRectangle(cornerRadius: 4))
        .padding(.top, 20)
        .task {
            try? await Task.sleep(for: .seconds(0.5))
            self.focused = true
        }
    }
    
    private var recentSearchHeader: some View {
        HStack{
            Text("최근 검색어")
                .font(.pretendardSemiBold(16))
            Spacer()
            Text("전체 삭제")
                .font(.pretendardRegular(16))
                .foregroundStyle(.tjGray2)
                .onTapGesture {
                    viewModel.send(.deleteAllRecentSearch)
                }
        }
        .padding(.top, 20)
    }
    
    private var recentSearchContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.state.recentSearchList, id: \.self) { text in
                    recentSearchCell(text)
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 15)
        }
    }
    
    private var emptyView: some View {
        VStack(alignment: .leading) {
            Text("최근 검색어가 없습니다.")
                .font(.pretendardRegular(16))
                .foregroundStyle(.tjGray2)
            Spacer()
        }
        .padding(.top, 30)
    }
    
    private func recentSearchCell(_ text: String) -> some View {
        HStack {
            Text(text)
                .font(.pretendardRegular(16))
            Spacer()
            Image(.tjClose)
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    viewModel.send(.deleteRecentSearch(text))
                }
        }
        .padding(.horizontal, 10)
        .frame(height: 50.adjustedH)
    }
    
    private var searchResultView: some View {
        VStack(spacing: 0) {
            CustomSegmentedControl(
                options: [
                    "여행자",
                    "여행 일지",
                    "플레이스"
                ],
                selectedIndex: Binding(
                    get: { viewModel.state.selectedSegmentIndex },
                    set: { viewModel.send(.selectSegment($0)) }
                ),
                namespace: namespace
            )
            .padding(.top, 20)
            
            TabView(selection: Binding(
                get: { viewModel.state.selectedSegmentIndex },
                set: { viewModel.send(.selectSegment($0)) }
            )) {
                travelerListView
                    .tag(0)
                    .onAppear {
                        viewModel.send(.travelerListViewOnAppear)
                    }
                
                travelJournalListView
                    .tag(1)
                    .onAppear {
                        viewModel.send(.travelJournalListViewOnAppear)
                    }
                
                placeListView
                    .tag(2)
                    .onAppear {
                        viewModel.send(.placeListViewOnAppear)
                    }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.top, 20)
        }
    }
    
    private var travelerListView: some View {
        ScrollView {
            ForEach(0..<2) { user in
                UserSummaryView(userSummary: .mock(id: 0, nickname: "김마루마루"), viewType: .searching)
            }
        }
    }
    
    private var travelJournalListView: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                
                ForEach(0..<2) { journalSummary in
                    JournalListCell(.mock(id: 0, title: "ㅇㅇㅇㅇ"))
                }
                
//                if !viewModel.state.isLastJournalsPage {
//                    ProgressView()
//                        .task {
//                            viewModel.send(.journalListNextPageOnAppear)
//                        }
//                }
            }
        }
    }
    
    private var placeListView: some View {
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: 5),
            count: 2
        )
        
        return ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(0..<2) { list in
                    PlaceGridCell(.mock(id: 0, placeName: "어쩌구 추천"))
                }
                
//                if !viewModel.state.isLastPlacesPage {
//                    ProgressView()
//                    ProgressView()
//                        .task {
//                            viewModel.send(.placeGridNextPageOnAppear)
//                        }
//                }
            }
        }
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel())
}
