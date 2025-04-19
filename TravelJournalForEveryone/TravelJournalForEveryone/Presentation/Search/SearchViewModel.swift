//
//  SearchViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/19/25.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    private var cancellables: Set<AnyCancellable> = []
    
    func send(_ intent: Intent) {
        switch intent {
        case .viewOnAppear:
            handleViewOnAppear()
        case .enterSearchText(let text):
            state.searchText = text
        case .deleteSearchText:
            state.searchText = ""
        }
    }
}

extension SearchViewModel {
    struct State {
        var searchText: String = ""
        var recentSearchList: [String] = []
    }
    
    enum Intent {
        case viewOnAppear
        case enterSearchText(String)
        case deleteSearchText
    }
}

extension SearchViewModel {
    private func handleViewOnAppear() {
        
    }
}
