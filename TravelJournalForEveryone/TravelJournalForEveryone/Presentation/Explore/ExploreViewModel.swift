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
    
    private let fetchExploreJournalsUseCase: FetchExploreJournalsUseCase
    private let markJournalsUseCase: MarkJournalsUseCase
    
    private var currentPageNumber: Int = 0
    private var journalIDsAsSeen: Set<Int> = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        fetchExploreJournalsUseCase: FetchExploreJournalsUseCase,
        markJournalsUseCase: MarkJournalsUseCase
    ) {
        self.fetchExploreJournalsUseCase = fetchExploreJournalsUseCase
        self.markJournalsUseCase = markJournalsUseCase
    }
    
    func send(_ intent: Intent) {
        switch intent {
        case .journalListViewOnAppear:
            fetchJournals()
        case .journalListNextPageOnAppear:
            fetchJournals()
        case .refreshJournals:
            refreshJournals()
        case .seeJournal(let id):
            seeJournal(id: id)
        case .journalListViewOnDisappear:
            postJournalIDsAsSeen()
        }
    }
}

extension ExploreViewModel {
    struct State {
        var journalSummaries: [ExploreJournalSummary] = []
        var isJournalsInitialLoading: Bool = true
        var isLastJournalsPage: Bool = false
    }
    
    enum Intent {
        case journalListViewOnAppear
        case journalListNextPageOnAppear
        case refreshJournals
        case seeJournal(id: Int)
        case journalListViewOnDisappear
    }
}

extension ExploreViewModel {
    private func fetchJournals() {
        fetchExploreJournalsUseCase.execute(pageNumber: currentPageNumber)
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
                    self.state.journalSummaries.append(contentsOf: journalsPage.contents)
                    self.state.isLastJournalsPage = journalsPage.isLast
                    self.currentPageNumber += 1
                }
            }
            .store(in: &cancellables)
    }
    
    private func refreshJournals() {
        postJournalIDsAsSeen()
        
        self.state.isJournalsInitialLoading = true
        self.currentPageNumber = 0
        
        fetchJournals()
    }
    
    private func seeJournal(id: Int) {
        journalIDsAsSeen.insert(id)
    }
    
    private func postJournalIDsAsSeen() {
        guard !self.journalIDsAsSeen.isEmpty else { return }
        
        markJournalsUseCase.execute(journalIDs: Array(journalIDsAsSeen))
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("⛔️ Mark Journals Error: \(error)")
                }
            } receiveValue: { [weak self] isSuccess in
                guard let self else { return }
                
                if isSuccess {
                    self.journalIDsAsSeen.removeAll()
                }
            }
            .store(in: &cancellables)
    }
}
