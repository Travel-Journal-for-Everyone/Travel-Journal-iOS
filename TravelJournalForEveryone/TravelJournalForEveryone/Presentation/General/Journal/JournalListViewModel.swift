//
//  JournalListViewModel.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/8/25.
//

import Foundation
import Combine

// MARK: - State
struct JournalListState {
    var viewType: JournalListType = .all(.journal)
    var navigationTitle: String = ""
    var selectedSegmentIndex: Int = 0
    var journalSummaries: [JournalSummary] = []
    var journalSummariesCount: Int = 0
    // TEST
    var placeSummaries: [JournalSummary] = []
    var placeSummariesCount: Int = 0
}


// MARK: - Intent
enum JournalListIntent {
    case journalListViewOnAppear
    case placeGridViewOnAppear
    case selectSegment(Int)
}


// MARK: - ViewModel(State + Intent)
final class JournalListViewModel: ObservableObject {
    @Published private(set) var state = JournalListState()
    
    init(viewType: JournalListType) {
        self.state.viewType = viewType
        
        updateSegmentIndex()
        updateNavigationTitle()
    }
    
    func send(_ intent: JournalListIntent) {
        switch intent {
        case .journalListViewOnAppear:
            handleJournalListViewOnAppear()
        case .placeGridViewOnAppear:
            handlePlaceGridViewOnAppear()
        case .selectSegment(let index):
            handleSelectSegment(index)
        }
    }
    
    private func handleJournalListViewOnAppear() {
        // TEST - onAppear 될 때마다 API 통신되는 지 추후 확인하기.
        self.state.journalSummaries = [
            .mock(title: "바다만 주구장창 보았던 부산 여행 🌊"),
            .mock(title: "가을 느낌 한가득! 울산 간월제 등산️ ⛰️"),
            .mock(title: "맛집 한가득 입이 행복했던 대구 😋"),
        ]
    }
    
    private func handlePlaceGridViewOnAppear() {
        
    }
    
    private func handleSelectSegment(_ index: Int) {
        self.state.selectedSegmentIndex = index
        
        if self.state.viewType == .save {
            updateNavigationTitle()
        }
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
}
