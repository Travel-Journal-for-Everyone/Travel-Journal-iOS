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
    
    private let searchMembersUseCase: SearchMembersUseCase
    private var isSearched: Bool = false
    
    private var currentMembersPageNumber: Int = 0
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(searchMembersUseCase: SearchMembersUseCase) {
        self.searchMembersUseCase = searchMembersUseCase
    }
    
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
            state.searchState = .beforeSearch
        case .onSubmit:
            resetSearching()
            isSearched = true
            addRecentSearch(state.searchText)
            searchMembers(state.searchText)
        case .deleteRecentSearch(let text):
            deleteRecentSearch(text)
        case .deleteAllRecentSearch:
            deleteAllRecentSearch()
        case .searchByRecentSearch(let text):
            addRecentSearch(text)
            resetSearching()
            isSearched = true
            state.searchText = text
            switch state.selectedSegmentIndex {
            case 0:
                searchMembers(text)
            case 1:
                break
            case 2:
                break
            default:
                break
            }
        case .selectSegment(let index):
            state.selectedSegmentIndex = index
        case .travelerListViewOnAppear:
            if !state.searchText.isEmpty, isSearched {
                searchMembers(state.searchText)
            }
        case .travelerListNextOnAppear:
            searchMembers(state.searchText)
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
        
        var searchedTraveler: [UserSummary] = []
        var isLastSearchedTraveler: Bool = false
        var isLoading: Bool = false
    }
    
    enum Intent {
        case viewOnAppear
        case enterSearchText(String)
        case deleteSearchText
        case onSubmit
        
        case deleteRecentSearch(String)
        case deleteAllRecentSearch
        case searchByRecentSearch(String)
        
        case selectSegment(Int)
        
        case travelerListViewOnAppear
        case travelerListNextOnAppear
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
    
    // MARK: - Network
    private func searchMembers(_ keyword: String) {
        guard !state.isLastSearchedTraveler else { return }
        
        state.isLoading = true
        searchMembersUseCase.execute(
            keyword: keyword,
            pageNumber: currentMembersPageNumber
        )
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.state.isLoading = false
                    self?.state.searchState = .successSearch
                case .failure(let error):
                    self?.state.isLoading = false
                    print("⛔️ Search Traveler Error: \(error)")
                }
            } receiveValue: { [weak self] membersPage in
                guard let self else { return }
                
                self.state.searchedTraveler.append(
                    contentsOf: membersPage.contents
                )
                self.state.isLastSearchedTraveler = membersPage.isLast
                self.currentMembersPageNumber += 1
            }
            .store(in: &cancellables)
    }
    
    private func resetSearching() {
        state.isLastSearchedTraveler = false
        currentMembersPageNumber = 0
        state.searchedTraveler = []
        
        isSearched = false
    }
}
