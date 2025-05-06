//
//  ExploreViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/1/25.
//

import Foundation
import Combine

final class ExploreViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    @MainActor // TEST
    func send(_ intent: Intent) {
        switch intent {
        case .selectSegment(let index):
            self.state.selectedSegmentIndex = index
            
        case .journalListViewOnAppear:
            fetchJournals()
        case .journalListNextPageOnAppear:
            fetchJournals()
        case .refreshJournals:
            refreshJournals()
            
        case .placeGridViewOnAppear:
            fetchPlaces()
        case .placeGridNextPageOnAppear:
            fetchPlaces()
        case .refreshPlaces:
            refreshPlaces()
        }
    }
}

extension ExploreViewModel {
    struct State {
        var selectedSegmentIndex: Int = 0
        
        var journalSummaries: [ExploreJournalSummary] = []
        var isJournalsInitialLoading: Bool = true
        var isLastJournalsPage: Bool = false
        
        var placesSummaries: [PlaceSummary] = []
        var isPlacesInitialLoading: Bool = true
        var isLastPlacesPage: Bool = false
    }
    
    enum Intent {
        case selectSegment(Int)
        
        case journalListViewOnAppear
        case journalListNextPageOnAppear
        case refreshJournals
        
        case placeGridViewOnAppear
        case placeGridNextPageOnAppear
        case refreshPlaces
    }
}

extension ExploreViewModel {
    @MainActor // TEST
    private func fetchJournals() {
        // TEST
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.state.isJournalsInitialLoading = false
            self.state.isLastJournalsPage = true
            
            self.state.journalSummaries = [
                .mock(id: 0, title: "바다만 주구장창 보았던 부산 여행 🌊"),
                .mock(id: 1, title: "바다만 주구장창 보았던 시흥 여행 🌊"),
                .mock(id: 2, title: "바다만 주구장창 보았던 서울 여행 🌊"),
                .mock(id: 3, title: "바다만 주구장창 보았던 제주 여행 🌊"),
                .mock(id: 4, title: "바다만 주구장창 보았던 강릉 여행 🌊"),
            ]
        }
    }
    
    private func refreshJournals() {
        print("여행 일지 목록 새로 고침")
    }
    
    @MainActor // TEST
    private func fetchPlaces() {
        // TEST
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.state.isPlacesInitialLoading = false
            self.state.isLastPlacesPage = true
            
            self.state.placesSummaries = [
                .mock(id: 0, placeName: "시흥"),
                .mock(id: 1, placeName: "주문진"),
                .mock(id: 2, placeName: "전주"),
                .mock(id: 3, placeName: "인덕원"),
                .mock(id: 4, placeName: "잠실"),
                .mock(id: 5, placeName: "부천"),
                .mock(id: 6, placeName: "광명"),
                .mock(id: 7, placeName: "제주"),
                .mock(id: 8, placeName: "부산"),
                .mock(id: 9, placeName: "강릉"),
                .mock(id: 10, placeName: "광진구"),
                .mock(id: 11, placeName: "해운대구"),
            ]
        }
    }
    
    private func refreshPlaces() {
        print("플레이스 목록 새로 고침")
    }
}
