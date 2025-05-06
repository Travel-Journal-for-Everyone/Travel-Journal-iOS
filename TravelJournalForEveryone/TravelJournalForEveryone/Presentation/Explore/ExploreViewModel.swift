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
        }
    }
}

extension ExploreViewModel {
    struct State {
        var selectedSegmentIndex: Int = 0
        
        var journalSummaries: [ExploreJournalSummary] = []
        var isJournalsInitialLoading: Bool = true
        var isLastJournalsPage: Bool = false
    }
    
    enum Intent {
        case selectSegment(Int)
        
        case journalListViewOnAppear
        case journalListNextPageOnAppear
        case refreshJournals
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
        print("새로 고침")
    }
}
