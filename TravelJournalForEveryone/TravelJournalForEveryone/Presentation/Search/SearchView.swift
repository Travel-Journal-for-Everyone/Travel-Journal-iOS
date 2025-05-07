//
//  SearchView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/2/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @EnvironmentObject private var coordinator: DefaultCoordinator
    @Namespace var namespace
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            searchBar(viewModel.state.searchText)
            switch viewModel.state.searchState {
            case .beforeSearch:
                if viewModel.state.recentSearchList.isEmpty {
                    recentSearchEmptyView
                } else {
                    recentSearchHeader
                    recentSearchContent
                        .padding(.horizontal, -16)
                }
            case .searching:
                Spacer()
            case .successSearch:
                searchResultView
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(.white)
        .ignoresSafeArea(.keyboard)
        .onAppear {
            viewModel.send(.viewOnAppear)
        }
        .onTapGesture {
            hideKeyboard()
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
            .submitLabel(.search)
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
            if viewModel.state.searchText.isEmpty {
                try? await Task.sleep(for: .seconds(0.5))
                self.focused = true
            }
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
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.state.recentSearchList, id: \.self) { text in
                        recentSearchCell(text)
                    }
                    
                }
                .padding(.horizontal, 26)
                .padding(.top, 15)
            }
            .scrollDismissesKeyboard(.immediately)
            .contentMargins(.bottom, 50)
        }
    }
    
    private var recentSearchEmptyView: some View {
        VStack(alignment: .leading) {
            Text("최근 검색어가 없습니다.")
                .font(.pretendardRegular(16))
                .foregroundStyle(.tjGray2)
            Spacer()
        }
        .padding(.top, 30)
    }
    
    private func recentSearchCell(_ text: String) -> some View {
        HStack(spacing: 0) {
            HStack {
                Text(text)
                    .font(.pretendardRegular(16))

                Spacer()
            }
            .contentShape(.rect)
            .onTapGesture {
                viewModel.send(.searchByRecentSearch(text))
                hideKeyboard()
            }
            
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
    
    private var emptyView: some View {
        VStack {
            Text("검색 결과가 없습니다.")
                .font(.pretendardMedium(16))
                .foregroundStyle(.tjGray2)
                .padding(.top, 271)
            Spacer()
        }
    }
    
    private var searchResultView: some View {
        VStack(spacing: 0) {
            CustomSegmentedControl(
                options: [
                    "여행 일지",
                    "플레이스",
                    "여행자"
                ],
                selectedIndex: Binding(
                    get: {
                        viewModel.state.selectedSegmentIndex },
                    set: { newIndex in
                        withAnimation { viewModel.send(.selectSegment(newIndex))
                        }
                    }
                ),
                namespace: namespace
            )
            .padding(.top, 20)
            
            ScrollView(.horizontal) {
                LazyHStack {
                    travelJournalListView
                        .containerRelativeFrame(.horizontal)
                        .contentMargins(.horizontal, 16)
                        .contentMargins(.bottom, 63.adjustedH)
                        .id(0)
                        .onAppear {
                            viewModel.send(.travelJournalListViewOnAppear)
                        }
                    
                    placeListView
                        .containerRelativeFrame(.horizontal)
                        .contentMargins(.horizontal, 16)
                        .contentMargins(.bottom, 63.adjustedH)
                        .id(1)
                        .onAppear {
                            viewModel.send(.placeListViewOnAppear)
                        }
                    
                    travelerListView
                        .containerRelativeFrame(.horizontal)
                        .contentMargins(.horizontal, 16)
                        .contentMargins(.bottom, 63.adjustedH)
                        .id(2)
                        .task {
                            viewModel.send(.travelerListViewOnAppear)
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
            .padding(.horizontal, -16)
        }
    }
    
    private var travelerListView: some View {
        Group {
            if !viewModel.state.searchedTraveler.isEmpty {
                ScrollView {
                    Color.clear.frame(height: 10)
                    
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.state.searchedTraveler, id: \.id) { user in
                            UserSummaryView(userSummary: user, viewType: .searching)
                                .contentShape(.rect)
                                .onTapGesture {
                                    coordinator.push(.myJournal(memberID: user.id))
                                }
                        }
                        
                        if !viewModel.state.isLastSearchedTraveler {
                            ProgressView()
                                .task {
                                    viewModel.send(.travelerListNextOnAppear)
                                }
                        }
                    }
                }
                .scrollIndicators(.visible)
                .contentMargins(.bottom, 46.adjustedH, for: .scrollIndicators)
                .contentMargins(0, for: .scrollIndicators)
            } else {
                emptyView
            }
        }
    }
    
    private var travelJournalListView: some View {
        ScrollView {
            Color.clear.frame(height: 10)
            
            LazyVStack(spacing: 15) {
                ForEach(0..<20) { journalSummary in
                    JournalListCell(.mock(id: 0, title: "ㅇㅇㅇㅇ"))
                }
            }
        }
        .scrollIndicators(.visible)
        .contentMargins(.bottom, 46.adjustedH, for: .scrollIndicators)
        .contentMargins(0, for: .scrollIndicators)
    }
    
    private var placeListView: some View {
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: 5),
            count: 2
        )
        
        return ScrollView {
            Color.clear.frame(height: 10)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(0..<14) { list in
                    PlaceGridCell(.mock(id: 0, placeName: "어쩌구 추천"))
                }
            }
        }
        .scrollIndicators(.visible)
        .contentMargins(.bottom, 46.adjustedH, for: .scrollIndicators)
        .contentMargins(0, for: .scrollIndicators)
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(searchMembersUseCase: DIContainer.shared.searchMembersUseCase))
}
