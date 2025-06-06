//
//  JournalPlaceListViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/8/25.
//

import Foundation
import Combine

final class JournalPlaceListViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    private let fetchJournalsUseCase: FetchJournalsUseCase
    private let fetchPlacesUseCase: FetchPlacesUseCase
    
    private let user: User
    private var regionName: String? = ""
    private var currentJournalsPageNumber: Int = 0
    private var currentPlacesPageNumber: Int = 0
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        fetchJournalsUseCase: FetchJournalsUseCase,
        fetchPlacesUseCase: FetchPlacesUseCase,
        user: User,
        viewType: JournalListType
    ) {
        self.fetchJournalsUseCase = fetchJournalsUseCase
        self.fetchPlacesUseCase = fetchPlacesUseCase
        self.user = user
        self.state.viewType = viewType
        
        updateSegmentIndex()
        updateNavigationTitle()
        updateSummaryCount()
        updateRegionName()
    }
    
    func send(_ intent: Intent) {
        switch intent {
        case .journalListViewOnAppear:
            fetchJournals()
        case .journalListNextPageOnAppear:
            fetchJournals()
        case .placeGridViewOnAppear:
            fetchPlaces()
        case .placeGridNextPageOnAppear:
            fetchPlaces()
        case .selectSegment(let index):
            handleSelectSegment(index)
        }
    }
}

extension JournalPlaceListViewModel {
    struct State {
        var viewType: JournalListType = .all(.journal)
        var navigationTitle: String = ""
        var selectedSegmentIndex: Int = 0
        var journalSummaries: [JournalSummary] = []
        var journalSummariesCount: Int = 0
        var placeSummaries: [PlaceSummary] = []
        var placeSummariesCount: Int = 0
        var isJournalsInitialLoading: Bool = true
        var isPlacesInitialLoading: Bool = true
        var isLastJournalsPage: Bool = false
        var isLastPlacesPage: Bool = false
    }
    
    enum Intent {
        case journalListViewOnAppear
        case journalListNextPageOnAppear
        case placeGridViewOnAppear
        case placeGridNextPageOnAppear
        case selectSegment(Int)
    }
}

extension JournalPlaceListViewModel {
    private func handleSelectSegment(_ index: Int) {
        self.state.selectedSegmentIndex = index
        
        if self.state.viewType == .save {
            updateNavigationTitle()
        }
    }
    
    private func fetchJournals() {
        guard !self.state.isLastJournalsPage else { return }
        
        fetchJournalsUseCase.execute(
            // TODO: - 임시로 memberID 넣었음
            memberID: 2,
            regionName: regionName,
            pageNumber: currentJournalsPageNumber
        )
        .sink { [weak self] completion in
            guard let self else { return }
            
            switch completion {
            case .finished:
                self.state.isJournalsInitialLoading = false
            case .failure(let error):
                print("⛔️ Fetch Journals Error: \(error)")
            }
        } receiveValue: { [weak self] journalsPage in
            guard let self else { return }
            
            if journalsPage.isEmpty {
                self.state.journalSummaries = []
            } else {
                self.state.journalSummaries.append(
                    contentsOf: journalsPage.contents
                )
                self.state.isLastJournalsPage = journalsPage.isLast
                self.currentJournalsPageNumber += 1
            }
        }
        .store(in: &cancellables)
    }
    
    private func fetchPlaces() {
        guard !self.state.isLastPlacesPage else { return }
        
        fetchPlacesUseCase.execute(
            // TODO: - 임시로 memberID 넣었음
            memberID: 2,
            regionName: regionName,
            pageNumber: currentPlacesPageNumber
        )
        .sink { [weak self] completion in
            guard let self else { return }
            
            switch completion {
            case .finished:
                self.state.isPlacesInitialLoading = false
            case .failure(let error):
                print("⛔️ Fetch Places Error: \(error)")
            }
        } receiveValue: { [weak self] placesPage in
            guard let self else { return }
            
            if placesPage.isEmpty {
                self.state.placeSummaries = []
            } else {
                self.state.placeSummaries.append(
                    contentsOf: placesPage.contents
                )
                self.state.isLastPlacesPage = placesPage.isLast
                self.currentPlacesPageNumber += 1
            }
        }
        .store(in: &cancellables)
    }
    
    private func updateSegmentIndex() {
        if self.state.viewType == .all(.journal) {
            self.state.selectedSegmentIndex = 0
        } else if self.state.viewType == .all(.place) {
            self.state.selectedSegmentIndex = 1
        }
    }
    
    private func updateNavigationTitle() {
        switch self.state.viewType {
        case .all:
            self.state.navigationTitle = "전체"
        case .region(let region):
            self.state.navigationTitle = "\(region.rawValue)"
        case .save:
            self.state.navigationTitle = self.state.selectedSegmentIndex == 0 ? "저장한 여행 일지" : "저장한 플레이스"
        case .like:
            self.state.navigationTitle = "좋아요한 여행 일지"
        }
    }
    
    private func updateSummaryCount() {
        switch self.state.viewType {
        case .all:
            self.state.journalSummariesCount = self.user.travelJournalCount
            self.state.placeSummariesCount = self.user.placesCount
        case .region(let region):
            let regionIndex: Int
            
            switch region {
            case .metropolitan: regionIndex = 0
            case .gangwon: regionIndex = 1
            case .chungcheong: regionIndex = 2
            case .gyeongsang: regionIndex = 3
            case .jeolla: regionIndex = 4
            case .jeju: regionIndex = 5
            }
            
            self.state.journalSummariesCount = self.user.regionDatas[regionIndex].travelJournalCount
            self.state.placeSummariesCount = self.user.regionDatas[regionIndex].placesCount
        case .save, .like:
            break
        }
    }
    
    private func updateRegionName() {
        switch self.state.viewType {
        case .all:
            self.regionName = nil
        case .region(let region):
            self.regionName = region.rawValue
        case .save, .like:
            break
        }
    }
}
