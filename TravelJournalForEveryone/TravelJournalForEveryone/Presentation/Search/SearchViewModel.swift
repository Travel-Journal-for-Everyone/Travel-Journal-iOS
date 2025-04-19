//
//  SearchViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/19/25.
//

import Foundation
import Combine

enum SearchState {
    case beforeSearch
    case searching
    case successSearch
}

final class SearchViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    private var cancellables: Set<AnyCancellable> = []
    
    func send(_ intent: Intent) {
        switch intent {
        case .viewOnAppear:
            handleViewOnAppear()
        case .enterSearchText(let text):
            state.searchText = text
            if !text.isEmpty {
                state.searchState = .searching
            }
        case .deleteSearchText:
            state.searchText = ""
        case .onSubmit:
            addRecentSearch(state.searchText)
            state.searchState = .successSearch
            // api 호출
        case .deleteRecentSearch(let text):
            deleteRecentSearch(text)
        case .deleteAllRecentSearch:
            deleteAllRecentSearch()
        case .selectSegment(let index):
            state.selectedSegmentIndex = index
        case .travelerListViewOnAppear:
            break
        case .travelJournalListViewOnAppear:
            break
        case .placeListViewOnAppear:
            break
        }
    }
}

extension SearchViewModel {
    struct State {
        var searchState: SearchState = .beforeSearch
        var searchText: String = ""
        var recentSearchList: [String] = []
        var selectedSegmentIndex = 0
    }
    
    enum Intent {
        case viewOnAppear
        case enterSearchText(String)
        case deleteSearchText
        case onSubmit
        
        case deleteRecentSearch(String)
        case deleteAllRecentSearch
        
        case selectSegment(Int)
        
        case travelerListViewOnAppear
        case travelJournalListViewOnAppear
        case placeListViewOnAppear
    }
}

extension SearchViewModel {
    private func handleViewOnAppear() {
        guard let list = UserDefaults.standard.array(
            forKey: UserDefaultsKey.recentSearches.value
        ) as? [String]
        else { return }
        
        state.recentSearchList = list
    }
    
    private func addRecentSearch(_ text: String) {
        if let index = state.recentSearchList.firstIndex(of: text) {
            state.recentSearchList.remove(at: index)
        }
        
        state.recentSearchList.insert(text, at: 0)
        UserDefaults.standard.set(state.recentSearchList, forKey: UserDefaultsKey.recentSearches.value)
    }
    
    private func deleteRecentSearch(_ text: String) {
        guard let index = state.recentSearchList.firstIndex(of: text) else { return }
            
        state.recentSearchList.remove(at: index)
        UserDefaults.standard.set(state.recentSearchList, forKey: UserDefaultsKey.recentSearches.value)
    }
    
    private func deleteAllRecentSearch() {
        state.recentSearchList = []
        UserDefaults.standard.set(state.recentSearchList, forKey: UserDefaultsKey.recentSearches.value)
    }
}
