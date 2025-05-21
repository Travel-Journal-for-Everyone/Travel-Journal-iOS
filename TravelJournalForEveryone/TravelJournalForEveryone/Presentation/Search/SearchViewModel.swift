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
    private let searchPlacesUseCase: SearchPlacesUseCase
    private let searchJournalsUseCase: SearchJournalsUseCase
    
    private var isSearched: Bool = false
    
    private var currentMembersPageNumber: Int = 0
    private var currentPlacePageNumber: Int = 0
    private var currentJournalPageNumber: Int = 0
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        searchMembersUseCase: SearchMembersUseCase,
        searchPlacesUseCase: SearchPlacesUseCase,
        searchJournalsUseCase: SearchJournalsUseCase
    ) {
        self.searchMembersUseCase = searchMembersUseCase
        self.searchPlacesUseCase = searchPlacesUseCase
        self.searchJournalsUseCase = searchJournalsUseCase
    }
    
    func send(_ intent: Intent) {
        switch intent {
        case .viewOnAppear:
            handleViewOnAppear()
        case .enterSearchText(let text):
            if state.searchText != text {
                state.searchText = text
                if !text.isEmpty {
                    state.searchState = .searching
                } else {
                    state.searchState = .beforeSearch
                }
            }
        case .deleteSearchText:
            state.searchText = ""
            state.searchState = .beforeSearch
        case .onSubmit:
            let trimmedText = state.searchText.replacingOccurrences(of: " ", with: "")
            if !trimmedText.isEmpty {
                resetSearching()
                isSearched = true
                addRecentSearch(trimmedText)
                searchJournals(trimmedText)
            }
        case .deleteRecentSearch(let text):
            deleteRecentSearch(text)
        case .deleteAllRecentSearch:
            deleteAllRecentSearch()
        case .searchByRecentSearch(let text):
            resetSearching()
            isSearched = true
            state.searchText = text
            searchMembers(text)
            addRecentSearch(text)
        case .selectSegment(let index):
            state.selectedSegmentIndex = index
            
        case .travelerListOnAppear, .travelerListNextOnAppear:
            searchMembers(state.searchText)
        case .placeListOnAppear, .placeListNextOnAppear:
            searchPlaces(state.searchText)
        case .journalListOnAppear, .journalListNextOnAppear:
            searchJournals(state.searchText)
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
        
        var searchedPlaces: [PlaceSummary] = []
        var isLastSearchedPlace: Bool = false
        
        var searchedJournals: [JournalSummary] = []
        var isLastSearchedJournal: Bool = false
        
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
        
        case travelerListOnAppear
        case travelerListNextOnAppear
        
        case journalListOnAppear
        case journalListNextOnAppear
        
        case placeListOnAppear
        case placeListNextOnAppear
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
    
    private func searchPlaces(_ keyword: String) {
        guard !state.isLastSearchedPlace else { return }
        
        state.isLoading = true
        searchPlacesUseCase.execute(
            keyword: keyword,
            pageNumber: currentPlacePageNumber
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
        } receiveValue: { [weak self] page in
            guard let self else { return }
            
            self.state.searchedPlaces.append(
                contentsOf: page.contents
            )
            self.state.isLastSearchedPlace = page.isLast
            self.currentPlacePageNumber += 1
        }
        .store(in: &cancellables)
    }
    
    private func searchJournals(_ keyword: String) {
        guard !state.isLastSearchedJournal else { return }
        
        state.isLoading = true
        searchJournalsUseCase.execute(
            keyword: keyword,
            pageNumber: currentJournalPageNumber
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
        } receiveValue: { [weak self] page in
            guard let self else { return }
            
            self.state.searchedJournals.append(
                contentsOf: page.contents
            )
            self.state.isLastSearchedJournal = page.isLast
            self.currentJournalPageNumber += 1
        }
        .store(in: &cancellables)
    }
    
    private func resetSearching() {
        state.selectedSegmentIndex = 0
        
        state.isLastSearchedTraveler = false
        state.isLastSearchedPlace = false
        state.isLastSearchedJournal = false
        
        currentMembersPageNumber = 0
        currentPlacePageNumber = 0
        currentJournalPageNumber = 0
        
        state.searchedTraveler = []
        state.searchedPlaces = []
        state.searchedJournals = []
        
        isSearched = false
    }
}
