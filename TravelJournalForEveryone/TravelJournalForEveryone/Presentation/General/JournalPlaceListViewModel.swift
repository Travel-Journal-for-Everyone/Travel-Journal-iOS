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
    
    private let user: User
    
    init(
        user: User,
        viewType: JournalListType
    ) {
        self.user = user
        self.state.viewType = viewType
        
        updateSegmentIndex()
        updateNavigationTitle()
        updateSummaryCount()
    }
    
    func send(_ intent: Intent) {
        switch intent {
        case .journalListViewOnAppear:
            handleJournalListViewOnAppear()
        case .placeGridViewOnAppear:
            handlePlaceGridViewOnAppear()
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
    }
    
    enum Intent {
        case journalListViewOnAppear
        case placeGridViewOnAppear
        case selectSegment(Int)
    }
}

extension JournalPlaceListViewModel {
    private func handleJournalListViewOnAppear() {
        // TEST - onAppear 될 때마다 API 통신되는 지 추후 확인하기.
        self.state.journalSummaries = [
            .mock(id: 0, title: "바다만 주구장창 보았던 부산 여행 🌊"),
            .mock(id: 1, title: "가을 느낌 한가득! 울산 간월제 등산️ ⛰️"),
            .mock(id: 2, title: "맛집 한가득 입이 행복했던 대구 😋"),
            .mock(id: 3, title: "주구장창 보았던 부산 여행 🌊"),
            .mock(id: 4, title: "느낌 한가득! 울산 간월제 등산️ ⛰️"),
            .mock(id: 5, title: "한가득 입이 행복했던 대구 😋"),
            .mock(id: 6, title: "바다만 주구장창 보았던 부산 🌊"),
            .mock(id: 7, title: "가을 느낌 한가득! 울산 간월제 ⛰️"),
            .mock(id: 8, title: "맛집 한가득 입이 행복했던 😋"),
        ]
    }
    
    private func handlePlaceGridViewOnAppear() {
        // TEST - onAppear 될 때마다 API 통신되는 지 추후 확인하기.
        self.state.placeSummaries = [
            .mock(id: 0, placeName: "이기대 해안산책로"),
            .mock(id: 1, placeName: "해운대 해변열차"),
            .mock(id: 2, placeName: "웨이브온 커피"),
            .mock(id: 3, placeName: "해운대 더베이"),
            .mock(id: 4, placeName: "은계 호수공원"),
            .mock(id: 5, placeName: "이기대 해안산"),
            .mock(id: 6, placeName: "해운대 해변"),
            .mock(id: 7, placeName: "웨이브온"),
            .mock(id: 8, placeName: "해운대 더베"),
            .mock(id: 9, placeName: "은계 호수"),
        ]
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
}
